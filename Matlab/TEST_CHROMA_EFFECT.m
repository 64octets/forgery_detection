function OUT = TEST_CHROMA_EFFECT(img_path)

    Img = imread(img_path);
    YCbCr = rgb2ycbcr(Img);
    Y  = YCbCr(:,:,1);
    Cb = YCbCr(:,:,2);
    Cr = YCbCr(:,:,3);

    %(Cr - Y) - (Cb - Y)
    %OUT = imsubtract(imsubtract(Cr,Y),imsubtract(Cb,Y));
    %figure, imshow(OUT);
    %figure, imshow(OUT * 10);
    
    %(Cb - Y) - (Cr - Y)
    %OUT = imsubtract(imsubtract(Cr,Y),imsubtract(Cb,Y));

    %(Cr - Y) + (Cb - Y)
    %OUT = imadd(imsubtract(Cr,Y),imsubtract(Cb,Y));
    %figure, imshow(OUT);
    %figure, imshow(OUT * 10);
    
    %(Cr - Cb)
    OUT = imsubtract(Cr,Cb);
    figure('name','(Cr-Cb)'); imshow(OUT);
    figure('name','(Cr-Cb)x10'); imshow(OUT * 10);
end