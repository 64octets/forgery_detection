function NoiseMap = displayNoiseEstimationMap(img_path)
    I = rgb2gray(imread(img_path));
    I = double(I);
    M=[1 -2 1; -2 4 -2; 1 -2 1];
    NoiseMap = abs(conv2(I, M));
    figure, imshow(NoiseMap);
end