
function output = CrossFeatureTest_rgb (img_path, resaved_img_path, block_size, q_multi_factor)

    FEATURE = 2; % 1 for quantization, 2 for noise estimation, 3 for interpolation, 4 for kurtosis
    COMBINATION = 2; % 1-G:B; 2-R:B; 3-R:G

    if FEATURE == 1
        Img = getQuatizationNoiseMap(img_path, resaved_img_path, q_multi_factor); % for entire images
        R  = Img(:,:,1);
        G = Img(:,:,2);
        B = Img(:,:,3);

        R_local  = getBlockQuatizationNoiseVarianceMap(R, block_size);
        G_local = getBlockQuatizationNoiseVarianceMap(G, block_size);
        B_local = getBlockQuatizationNoiseVarianceMap(B, block_size);
    elseif FEATURE == 2
        Img = imread(img_path);
        R  = NoiseEstimate(Img(:,:,1));
        G = NoiseEstimate(Img(:,:,2));
        B = NoiseEstimate(Img(:,:,3));

        R_local  = getNoiseEstimationMapByBlocks(Img(:,:,1), block_size);
        G_local = getNoiseEstimationMapByBlocks(Img(:,:,2), block_size);
        B_local = getNoiseEstimationMapByBlocks(Img(:,:,3), block_size);
    elseif FEATURE == 4
        Img = imread(img_path);
        R  = mean(kurtosis(double(Img(:,:,1))));
        G = mean(kurtosis(double(Img(:,:,2))));
        B = mean(kurtosis(double(Img(:,:,3))));

        R_local  = getKurtosisMapByBlocks(Img(:,:,1), block_size);
        G_local = getKurtosisMapByBlocks(Img(:,:,2), block_size);
        B_local = getKurtosisMapByBlocks(Img(:,:,3), block_size);
    end
    
    %- compute pricipal vector of the whole image --
    %compute variance for qmap and imap
    if FEATURE == 1
        if COMBINATION == 1
            var_all1 = var(double(G(:)));
            var_all2 = var(double(B(:)));
        elseif COMBINATION == 2
            var_all1 = var(double(R(:)));
            var_all2 = var(double(B(:)));
        elseif COMBINATION == 3
            var_all1 = var(double(R(:)));
            var_all2 = var(double(G(:)));
        end
    elseif FEATURE == 2 || FEATURE == 4
        if COMBINATION == 1
           var_all1 = G;
           var_all2 = B;
        elseif COMBINATION == 2
           var_all1 = R;
           var_all2 = B;
        elseif COMBINATION == 3
           var_all1 = R;
           var_all2 = G;
        end
    end
    %Principal_vect = [Noise_all Kurtosis_all 0];
    Principal_vect = [var_all1 var_all2 0];
    %-----------------------------------------------
    
    [w h] = size(G_local);
    output = zeros(w,h);
    
    for i = 1:w
        for j = 1:h
         
         %V.   construct vector of results
         %vect = [nmap(i,j) kmap(i,j) 0];
         
        if COMBINATION == 1
            vect = [G_local(i,j) B_local(i,j) 0];
        elseif COMBINATION == 2
            vect = [R_local(i,j) B_local(i,j) 0];
        elseif COMBINATION == 3
            vect = [R_local(i,j) G_local(i,j) 0];
        end
         
         %vect = [imap(i,j) qmap(i,j) 0];
         
         %VI.  do cross product
         %out_vect = cross(vect, Principal_vect);
         out_vect = cross(Principal_vect, vect);
         output(i,j) = out_vect(1,3);
        end
    end
    
    %adjust value range of the output
    output = abs(output);

    %figure, bar3(output);
    figure, surf(output);
    figure('name','Proposed Algorithm'); displayMatrixInColorImage(output);
    figure('name','R'); imshow(Img(:,:,1));
    figure('name','G'); imshow(Img(:,:,2));
    figure('name','B'); imshow(Img(:,:,3));
    
    if FEATURE == 1
        figure('name','Original Image'); imshow(img_path);
        figure('name','Qmap RGB'); imshow(Img);
        figure('name','Qmap R'); imshow(R);
        figure('name','Qmap G'); imshow(G);
        figure('name','Qmap B'); imshow(B);
    elseif FEATURE == 2
        figure('name','Original Image'); imshow(img_path);
        figure('name','Nmap R');  displayMatrixInColorImage(R_local);
        figure('name','Nmap G'); displayMatrixInColorImage(G_local);
        figure('name','Nmap B'); displayMatrixInColorImage(B_local);
    elseif FEATURE == 4
        figure('name','Original Image'); imshow(img_path);
        figure('name','Kmap R');  displayMatrixInColorImage(R_local);
        figure('name','Kmap G'); displayMatrixInColorImage(G_local);
        figure('name','Kmap B'); displayMatrixInColorImage(B_local);
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
    fprintf('preform noise estimation on image with size: (%i, %i)  block_size = %i', size(IMG, 1), size(IMG, 2), block_size);
    %III. estimate noise on each blocks
    [img_w img_h] = size(IMG);
    i = 1;
    output = zeros(int8(img_w/block_size), int8(img_h/block_size));
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
    fprintf('preform kurotsis estimation on image with size: (%i, %i) block_size = %i', size(IMG, 1), size(IMG, 2), block_size);
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