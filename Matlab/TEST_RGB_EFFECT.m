function TEST_RGB_EFFECT(img_path)
    Img = imread(img_path);
    R = Img(:,:,1);
    G = Img(:,:,2);
    B = Img(:,:,3);
    
    % show results
    figure('name','R'); imshow(R);
    figure('name','G'); imshow(G);
    figure('name','B'); imshow(B);
    figure('name','G-B-R'); imshow(imsubtract(imsubtract(G,B),R) * 100);
end