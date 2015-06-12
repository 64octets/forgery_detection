function output = getNoiseEstimationMapByBlocks (IMG, block_size)
    %I.   read image
    %IMG = rgb2gray(imread(img_path));

    %II.  split images into arrays of blocks
    %fprintf('preform noise estimation on image with size: (%i, %i)', size(IMG, 1), size(IMG, 2));
    
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