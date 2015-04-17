
function output = CrossFeatureTest_chroma_3d (img_path, resaved_img_path, block_size, q_multi_factor)

    FEATURE = 1; % 1 for quantization, 2 for noise estimation, 3 for interpolation, 4 for kurtosis
    %COMBINATION = 1; % 1-Cb:Cr; 2-Y:Cr; 3-Y:Cb
    
    if FEATURE == 1
        Img = getQuatizationNoiseMap(img_path, resaved_img_path, q_multi_factor); % for entire images
        YCbCr = rgb2ycbcr(Img);
        Y  = YCbCr(:,:,1);
        Cb = YCbCr(:,:,2);
        Cr = YCbCr(:,:,3);

        Y_local  = getBlockQuatizationNoiseVarianceMap(Y, block_size);
        Cb_local = getBlockQuatizationNoiseVarianceMap(Cb, block_size);
        Cr_local = getBlockQuatizationNoiseVarianceMap(Cr, block_size);
    elseif FEATURE == 2
        Img = imread(img_path);
        YCbCr = rgb2ycbcr(Img);
        Y  = NoiseEstimate(YCbCr(:,:,1));
        Cb = NoiseEstimate(YCbCr(:,:,2));
        Cr = NoiseEstimate(YCbCr(:,:,3));

        Y_local  = getNoiseEstimationMapByBlocks(YCbCr(:,:,1), block_size);
        Cb_local = getNoiseEstimationMapByBlocks(YCbCr(:,:,2), block_size);
        Cr_local = getNoiseEstimationMapByBlocks(YCbCr(:,:,3), block_size);
    elseif FEATURE == 4
        Img = imread(img_path);
        YCbCr = rgb2ycbcr(Img);
        Y  = mean(kurtosis(double(YCbCr(:,:,1))));
        Cb = mean(kurtosis(double(YCbCr(:,:,2))));
        Cr = mean(kurtosis(double(YCbCr(:,:,3))));

        Y_local  = getKurtosisMapByBlocks(YCbCr(:,:,1), block_size);
        Cb_local = getKurtosisMapByBlocks(YCbCr(:,:,2), block_size);
        Cr_local = getKurtosisMapByBlocks(YCbCr(:,:,3), block_size);
    end
    
    %- compute pricipal vector of the whole image --
    %compute variance for qmap and imap
    if FEATURE == 1
        var_all0 = var(double(Y(:)));
        var_all1 = var(double(Cb(:)));
        var_all2 = var(double(Cr(:)));
    elseif FEATURE == 2 || FEATURE == 4
        var_all0 = Y;
        var_all1 = Cb;
        var_all2 = Cr;
    end
    %Principal_vect = [Noise_all Kurtosis_all 0];
    Principal_vect = [var_all0 var_all1 var_all2];
    %-----------------------------------------------
    
    [w h] = size(Cb_local);
    output = zeros(w,h);
    
    for i = 1:w
        for j = 1:h
         
         %V.   construct vector of results
         %vect = [nmap(i,j) kmap(i,j) 0];
         
        vect = [Y_local(i,j) Cb_local(i,j) Cr_local(i,j)];
         
         %vect = [imap(i,j) qmap(i,j) 0];
         
         %VI.  do cross product
         %out_vect = cross(vect, Principal_vect);
         out_vect = cross(Principal_vect, vect);
         %{
         output(i,j) = sqrt(out_vect(1,1)^2 + out_vect(1,2)^2 + out_vect(1,3)^2);
         if (out_vect(1,1) * out_vect(1,2) * out_vect(1,3)) < 0
            output(i,j) = -output(i,j);
         end
         %}
         output(i,j) = 100 * (out_vect(1,1) + out_vect(1,2) + out_vect(1,3));
        end
    end
    
    %adjust value range of the output
    output = abs(output);

    %figure, bar3(output);
    figure, surf(output);
    figure('name','Proposed Algorithm'); displayMatrixInColorImage(output);
    figure('name','Y'); imshow(YCbCr(:,:,1));
    figure('name','Cb'); imshow(YCbCr(:,:,2));
    figure('name','Cr'); imshow(YCbCr(:,:,3));
    
    if FEATURE == 1
        figure('name','Original Image'); imshow(img_path);
        figure('name','Qmap RGB'); imshow(Img);
        figure('name','Qmap Y'); imshow(Y);
        figure('name','Qmap Cb'); imshow(Cb);
        figure('name','Qmap Cr'); imshow(Cr);
    elseif FEATURE == 2
        figure('name','Original Image'); imshow(img_path);
        figure('name','Nmap Y');  displayMatrixInColorImage(Y_local);
        figure('name','Nmap Cb'); displayMatrixInColorImage(Cb_local);
        figure('name','Nmap Cr'); displayMatrixInColorImage(Cr_local);
    elseif FEATURE == 4
        figure('name','Original Image'); imshow(img_path);
        figure('name','Kmap Y');  displayMatrixInColorImage(Y_local);
        figure('name','Kmap Cb'); displayMatrixInColorImage(Cb_local);
        figure('name','Kmap Cr'); displayMatrixInColorImage(Cr_local);
    end
    
    %figure, plot(output_vector); % output in sequence signal
    %figure, imshow(output);
    %figure, displayMatrixInColorImage(nmap);
    %figure, displayMatrixInColorImage(kmap);
    %figure('name','Quantization Noise'); imshow(qmapImg);
    %figure('name','Re-Interpolation'); imshow(imapImg);
    %figure, displayMatrixInColorImage(imapImg);
end

function output = getNoiseEstimationMapByBlocks (IMG, block_size)
    %I.   read image
    %IMG = rgb2gray(imread(img_path));

    %II.  split images into arrays of blocks
    fprintf('preform noise estimation on image with size: (%i, %i)', size(IMG, 1), size(IMG, 2));
    
    %III. estimate noise on each blocks
    [img_w img_h] = size(IMG);
    i = 1;
    output = zeros(img_w/block_size, img_h/block_size);
    %output = zeros(10, 10);
    fprintf('\noutput size %i %i\n', size(output, 1), size(output, 2));
    m = 1;
    while (i + block_size <= img_w)
        j = 1;
        n = 1;
        while (j + block_size <= img_h)
            current_block = IMG((i:i+block_size),(j:j+block_size));
            Noise_each = NoiseEstimate(current_block);  
            %fprintf('noise each = %i\n', Noise_each);
            output(m,n) = Noise_each;            
            j = j + block_size;
            n = n + 1;
        end
        i = i + block_size;
        m = m + 1;
    end
end

function NoiseLv = NoiseEstimate(I)
	[H W]=size(I);
	I=double(I);

	% compute sum of absolute values of Laplacian
	M=[1 -2 1; -2 4 -2; 1 -2 1];
	NoiseLv = sum(sum(abs(conv2(I, M))));

	% scale sigma with proposed coefficients
	NoiseLv = NoiseLv * sqrt(0.5*pi)./(6*(W-2)*(H-2));
end

function output = getKurtosisMapByBlocks (IMG, block_size)
    %I.   read image
    %IMG = rgb2gray(imread(img_path));

    %II.  split images into arrays of blocks
    fprintf('preform kurotsis estimation on image with size: (%i, %i)', size(IMG, 1), size(IMG, 2));
    %blocks = mat2cell(IMG,block_size*ones(1,size(IMG,1)/block_size),block_size*ones(1,size(IMG,2)/block_size));
    %blocks = mat2tiles(im2double(IMG),[block_size,block_size]);
    %blocks = splitImageIntoBlocks(IMG, block_size, block_size);
    
    %III. estimate noise on each blocks
    [img_w img_h] = size(IMG);
    i = 1;
    output = zeros(img_w/block_size, img_h/block_size);
    %output = zeros(10, 10);
    fprintf('\noutput size %i %i\n', size(output, 1), size(output, 2));
    m = 1;

    while (i + block_size <= img_w)
        j = 1;
        n = 1;
        while (j + block_size <= img_h)
            current_block = IMG((i:i+block_size),(j:j+block_size));
            kurtosis_array = kurtosis(double(getNoiseFromImage(current_block)));  %[kur1, kur2, kur3, ..., kur block_size - 1]
            mean_val = mean(kurtosis_array);
            %fprintf('average kurtosis = %i\n', mean_val);
            output(m,n) = mean_val;            
            j = j + block_size;
            n = n + 1;
        end
        i = i + block_size;
        m = m + 1;
    end
    %{
    [w h] = size(blocks);
    output = zeros(w,h);
    for i = 1:w
        for j = 1:h
         Noise_each = NoiseEstimate(blocks{i,j});  
         output(i,j) = Noise_each;
        end
    end
    %}
end

function NoiseImg = getNoiseFromImage(I)
	I=double(I);
	% compute sum of absolute values of Laplacian
	M=[1 -2 1; -2 4 -2; 1 -2 1];
	NoiseImg = abs(conv2(I, M));
end