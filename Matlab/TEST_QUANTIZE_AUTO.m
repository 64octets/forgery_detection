function output = TEST_QUANTIZE_AUTO (img_path, resaved_img_path, block_size, q_multi_factor)
    qmapImg = getQuatizationNoiseMap(img_path, resaved_img_path, q_multi_factor); % for entire images
    output = qmapImg;
    %qmap = getBlockQuatizationNoiseVarianceMap(qmapImg, block_size);
    %output = qmap;
end