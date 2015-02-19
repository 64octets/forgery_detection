%this function will return the re-interpolation noise variance of each block of
%images.
function reinterpolation_var_map = getBlockInterpolateDetectionVarianceMap (imap, block_size)

    % imap is denoted as re-interpolation noise map of entire image

    %II.  split images into arrays of blocks
    %fprintf('perform re-interpolation variance estimation on image with size: (%i, %i)', size(imap, 1), size(imap, 2));
    
    %III. estimate noise on each blocks
    [img_w img_h] = size(imap);
    i = 1;
    %output = zeros(img_w/block_size, img_h/block_size);
    output = zeros(10, 10);
    m = 1;
    while (i + block_size <= img_w)
        j = 1;
        n = 1;
        while (j + block_size <= img_h)
            current_block = imap((i:i+block_size),(j:j+block_size));
            Var_INoise_each = var(double(current_block(:)));  
            %fprintf('inoise each = %i\n', Noise_each);
            output(m,n) = Var_INoise_each;            
            j = j + block_size;
            n = n + 1;
        end
        i = i + block_size;
        m = m + 1;
    end
    reinterpolation_var_map = output;
end