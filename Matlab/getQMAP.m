% this function responsible for creating map of 
% JPEG Quantization noise
% from EACH IMAGE BLOCK.

function output = getQMAP (img_path, block_size, is_quantize, have_block_process)

    multiplication_factor = 0;

    %-------------------------GET RAW QMAP--------------------------------%
    resaved_img_path = strrep(img_path, '.jpg', '_re.jpg');

    original = imread(img_path);
    resaved = imread(resaved_img_path);
    diff = imsubtract(original, resaved);
    if(multiplication_factor > 0)
        diff = diff * multiplication_factor;
    end
    %figure, imshow(diff);
    quantization_noise_map = diff;
    %figure, imshow(quantization_noise_map);
    %---------------------------------------------------------------------%
    
    %-------------------GET BLOCKED DIVIDED QMAP--------------------------%
    if have_block_process == 1
    %turn RGB image into one color channel image
    quantization_noise_map = rgb2gray(quantization_noise_map);
    %quantization_noise_map = quantization_noise_map(:,:,2); %only Green
    %channel
        [img_w img_h] = size(quantization_noise_map);
        i = 1;
        qmap = zeros(int8(img_w/block_size), int8(img_h/block_size));
        m = 1;
        while (i + block_size <= img_w)
            j = 1;
            n = 1;
            while (j + block_size <= img_h)
                current_block = quantization_noise_map((i:i+block_size),(j:j+block_size));
                Var_QNoise_each = var(double(current_block(:)));
                qmap(m,n) = Var_QNoise_each;            
                j = j + block_size;
                n = n + 1;
            end
            i = i + block_size;
            m = m + 1;
        end

        if is_quantize == 1
            qmap = quantizingMatrix(qmap);
        end

        %return qmap
        keySet   = {'totalValue', 'detectionMAP'};
        valueSet = {mean(double(quantization_noise_map(:))), qmap}; 
        output   = containers.Map(keySet, valueSet);
    else
        output = quantization_noise_map;
    end
    %---------------------------------------------------------------------%
end