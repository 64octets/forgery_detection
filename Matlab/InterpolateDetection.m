function detection_map = InterpolateDetection (path)

    RGB = imread(path);
    O = FFT_IMG(RGB); %DFT: O
    
    %define N here
    N = 2;
    
    %********************************************************
    %********************************************************
    %Forged Region
    %x N
    f_s1_NN = imresize(RGB, N, 'nearest');
    f_s1_BL = imresize(RGB, N, 'bilinear');
    f_s1_BC = imresize(RGB, N, 'bicubic');
    %DFT: A
    A_NN = FFT_IMG(f_s1_NN);
    A_BL = FFT_IMG(f_s1_BL);
    A_BC = FFT_IMG(f_s1_BC);
    %--------------------------------------------------------
    
    %1/N
    f_s2_NN = imresize(f_s1_NN, (1/N), 'nearest');
    f_s2_BL = imresize(f_s1_BL, (1/N), 'bilinear');
    f_s2_BC = imresize(f_s1_BC, (1/N), 'bicubic');
    
    %--------------------------------------------------------
    %x N
    f_s3_NN = imresize(f_s2_NN, N, 'nearest');
    f_s3_BL = imresize(f_s2_BL, N, 'bilinear');
    f_s3_BC = imresize(f_s2_BC, N, 'bicubic');
    %DFT: B
    B_NN = FFT_IMG(f_s3_NN);
    B_BL = FFT_IMG(f_s3_BL);
    B_BC = FFT_IMG(f_s3_BC);
    %--------------------------------------------------------
    
    %output for Forged Region F = Diff A-B
    F_NN = A_NN - B_NN;
    F_BL = A_BL - B_BL;
    F_BC = A_BC - B_BC;
    
    %[fw, fh] = size(F_NN)
    %figure;imshow(A_NN);
    %figure;imshow(B_NN);
    %figure;imshow(F_NN);
    %figure;imshow(F_BL);
    %figure;imshow(F_BC);
    
    %********************************************************
    %********************************************************
    %Non-Forged Region
    %1/N
    nf_s1_NN = imresize(RGB, (1/N), 'nearest');
    nf_s1_BL = imresize(RGB, (1/N), 'bilinear');
    nf_s1_BC = imresize(RGB, (1/N), 'bicubic');
    
    %x N
    nf_s2_NN = imresize(nf_s1_NN, N, 'nearest');
    nf_s2_BL = imresize(nf_s1_BL, N, 'bilinear');
    nf_s2_BC = imresize(nf_s1_BC, N, 'bicubic');
    
    %DFT: C
    C_NN = FFT_IMG(nf_s2_NN);
    C_BL = FFT_IMG(nf_s2_BL);
    C_BC = FFT_IMG(nf_s2_BC);
    
    %output for Non-Forged Region G = Diff O-C
    size(O)
    size(C_NN)
    G_NN = O - C_NN;
    G_BL = O - C_BL;
    G_BC = O - C_BC;
    
    %[gw, gh] = size(G_NN)
    %figure;imshow(G_NN);
    
    %///////////////////////////////////////////////////////
    %///////////////////////////////////////////////////////
    %produce output forged detection map
    %F_NN = imresize(F_NN, (1/N), 'nearest');
    %F_BL = imresize(F_BL, (1/N), 'bilinear');
    %F_BC = imresize(F_BC, (1/N), 'bicubic');
    
    %BEST OUTPUT WE HAVE RIGHT NOW
    %figure; imshow(ifft2(G_NN));
    %figure; imshow(ifft2(G_BC));
    %figure; imshow(ifft2(G_BL));
    
    %figure; imshow(ifft2(F_NN));
    %figure; imshow(ifft2(F_BC));
    %figure; imshow(ifft2(F_BL));
    
    detection_map = ifft2(G_BL);
    %-----------------------------
    
    G_NN = imresize(G_NN, (N), 'nearest');
    G_BL = imresize(G_BL, (N), 'bilinear');
    G_BC = imresize(G_BC, (N), 'bicubic');
    
    DMAP_NN = F_NN - G_NN;
    DMAP_BL = F_BL - G_BL;
    DMAP_BC = F_BC - G_BC;
    
    %{
    F_NN = ifft2(F_NN);
    F_BL = ifft2(F_BL);
    F_BC = ifft2(F_BC);
    
    G_NN = ifft2(G_NN);
    G_BL = ifft2(G_BL);
    G_BC = ifft2(G_BC);
    
    DMAP_NN = imsubtract(F_NN, G_NN);
    DMAP_BL = imsubtract(F_BL, G_BL);
    DMAP_BC = imsubtract(F_BC, G_BC);
    %}
    
    %{
    %NN
    figure;
    %title('DMAP_NN_NO_IFFT');
    %imshow(DMAP_NN);
    %figure;
    title('DMAP_NN');
    imshow(ifft2(DMAP_NN));
    
    %BL
    figure;
    %title('DMAP_BL_NO_IFFT');
    %imshow(DMAP_BL);
    %figure;
    title('DMAP_BL');
    imshow(ifft2(DMAP_BL));
    
    %BC
    figure;
    %title('DMAP_BC_NO_IFFT');
    %imshow(DMAP_BC);
    %figure;
    title('DMAP_BC');
    imshow(ifft2(DMAP_BC));
    %}
end