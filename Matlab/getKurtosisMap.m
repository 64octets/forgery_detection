%this function responsible for creating map of noise estimated from each
%image section.

function output = getKurtosisMap (img_path, block_size)
    %I.   read image
    IMG = rgb2gray(imread(img_path));

    %II.  split images into arrays of blocks
    fprintf('preform kurotsis estimation on image with size: (%i, %i)', size(IMG, 1), size(IMG, 2));
    %blocks = mat2cell(IMG,block_size*ones(1,size(IMG,1)/block_size),block_size*ones(1,size(IMG,2)/block_size));
    %blocks = mat2tiles(im2double(IMG),[block_size,block_size]);
    %blocks = splitImageIntoBlocks(IMG, block_size, block_size);
    
    %III. estimate noise on each blocks
    [img_w img_h] = size(IMG);
    i = 1;
    %output = zeros(img_w/block_size, img_h/block_size);
    output = zeros(10, 10);
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