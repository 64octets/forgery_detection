%this function responsible for creating map of entropy estimated from each
%image section.

function output = getEntropyEstimationMap (img_path, block_size)
    %I.   read image
    IMG = rgb2gray(imread(img_path));

    %II.  split images into arrays of blocks
    blocks = mat2cell(IMG,block_size*ones(1,size(IMG,1)/block_size),block_size*ones(1,size(IMG,2)/block_size));

    %III. estimate noise on each blocks
    [w h] = size(blocks);
    output = zeros(w,h);
    for i = 1:w
        for j = 1:h
         Entropy_each = entropy(blocks{i,j});  
         output(i,j) = Entropy_each;
        end
    end
end