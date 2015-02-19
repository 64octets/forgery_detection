%this function will return the quantization noise variance of each block of
%images.
function quantization_noise_var_map = getBlockQuatizationNoiseVarianceMap(qmap, block_size)

    % qmap is denoted as the quantization noise map of entire image 

    %II.  split images into arrays of blocks
    %fprintf('perform quantization noise estimation on image with size: (%i, %i)', size(qmap, 1), size(qmap, 2));
    
    %III. estimate noise on each blocks
    [img_w img_h] = size(qmap);
    i = 1;
    %output = zeros(img_w/block_size, img_h/block_size);
    output = zeros(10, 10);
    m = 1;
    while (i + block_size <= img_w)
        j = 1;
        n = 1;
        while (j + block_size <= img_h)
            current_block = qmap((i:i+block_size),(j:j+block_size));
            Var_QNoise_each = var(double(current_block(:)));
            %fprintf('qnoise each = %i\n', Noise_each);
            output(m,n) = Var_QNoise_each;            
            j = j + block_size;
            n = n + 1;
        end
        i = i + block_size;
        m = m + 1;
    end
    quantization_noise_var_map = output;
end