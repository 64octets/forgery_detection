
function output = SubtractTestOnYCbCr (img_path, block_size)

        Img = imread(img_path);
        YCbCr = rgb2ycbcr(Img);
        Y  = NoiseEstimate(YCbCr(:,:,1));
        Cb = NoiseEstimate(YCbCr(:,:,2));
        Cr = NoiseEstimate(YCbCr(:,:,3));

        subt = imsubtract(imsubtract(YCbCr(:,:,3), YCbCr(:,:,1)),imsubtract(YCbCr(:,:,2), YCbCr(:,:,1)));
        sub_n_all = NoiseEstimate(subt);
        
        Y_local  = getNoiseEstimationMapByBlocks(YCbCr(:,:,1), block_size);
        Cb_local = getNoiseEstimationMapByBlocks(YCbCr(:,:,2), block_size);
        Cr_local = getNoiseEstimationMapByBlocks(YCbCr(:,:,3), block_size);
        
        sub_local = getNoiseEstimationMapByBlocks(subt, block_size);
        
        Principal_vect2 = [Cr sub_n_all 0];
        Principal_vect1 = [Cb sub_n_all 0];

        [w h] = size(Cb_local);
        output1 = zeros(w,h);
        output2 = zeros(w,h);
        
        for i = 1:w
            for j = 1:h
                vect1 = [Cb_local(i,j) sub_local(i,j) 0];
                vect2 = [Cr_local(i,j) sub_local(i,j) 0];

                out_vect1 = cross(Principal_vect1, vect1);
                out_vect2 = cross(Principal_vect2, vect2);
                
                output1(i,j) = out_vect1(1,3);
                output2(i,j) = out_vect2(1,3);
            end
        end

        %adjust value range of the output
        output1 = abs(output1);
        output2 = abs(output2);
        
        figure('name','Cb - Subt'); displayMatrixInColorImage(output1);
        figure('name','Cr - Subt'); displayMatrixInColorImage(output2);
        figure('name','Nmap Cr'); displayMatrixInColorImage(Cr_local);
        figure('name','Sub local'); displayMatrixInColorImage(sub_local);
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
    %fprintf('preform kurotsis estimation on image with size: (%i, %i)', size(IMG, 1), size(IMG, 2));
    %blocks = mat2cell(IMG,block_size*ones(1,size(IMG,1)/block_size),block_size*ones(1,size(IMG,2)/block_size));
    %blocks = mat2tiles(im2double(IMG),[block_size,block_size]);
    %blocks = splitImageIntoBlocks(IMG, block_size, block_size);
    
    %III. estimate noise on each blocks
    [img_w img_h] = size(IMG);
    i = 1;
    output = zeros(img_w/block_size, img_h/block_size);
    %output = zeros(10, 10);
    %fprintf('\noutput size %i %i\n', size(output, 1), size(output, 2));
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