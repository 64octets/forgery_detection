% this fuction will return the image from quantization process subtracted
% from the original image.
function quantization_noise_map = getQuatizationNoiseMap(img_path,resaved_img_path,multiplication_factor)
    original = imread(img_path);
    resaved = imread(resaved_img_path);
    diff = imsubtract(original, resaved);
    if(multiplication_factor > 0)
        diff = diff * multiplication_factor;
    end
    %figure, imshow(diff);
    quantization_noise_map = diff;
end