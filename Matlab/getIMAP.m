% this function responsible for creating detection map for re-interpolation processes 
% on EACH RE_INTERPOLATED IMAGE BLOCK.

function output = getIMAP (img_path, block_size)

    %--------------------GET RE_INTERPOLATED IMG---------------------------%
    %----------------------------------------------------------------------%
    RGB = imread(img_path);
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
    %size(O)
    %size(C_NN)
    G_NN = O - C_NN;
    G_BL = O - C_BL;
    G_BC = O - C_BC;

    %///////////////////////////////////////////////////////
    
    raw_detection_map = ifft2(G_BL);
    %-----------------------------
    %{
    G_NN = imresize(G_NN, (N), 'nearest');
    G_BL = imresize(G_BL, (N), 'bilinear');
    G_BC = imresize(G_BC, (N), 'bicubic');
    
    DMAP_NN = F_NN - G_NN;
    DMAP_BL = F_BL - G_BL;
    DMAP_BC = F_BC - G_BC;
    %}
    
    %figure('name','BC'), imshow(raw_detection_map);
    %---------------------END OF RE-INTERPOLATION--------------------------%
    
    % compute variance on each blocks
    
    % we use only one channel of RGB (i.e. Green) to prevent redundancy in results
    raw_detection_map = raw_detection_map(:,:,2); %G Channel of RGB
    
    [img_w img_h] = size(raw_detection_map);
    i = 1;
    
    imap = zeros(int8(img_w/block_size), int8(img_h/block_size));
    
    m = 1;
    while (i + block_size <= img_w)
        j = 1;
        n = 1;
        while (j + block_size <= img_h)
            current_block = raw_detection_map((i:i+block_size),(j:j+block_size));
            Var_INoise_each = var(double(current_block(:)));  
            %fprintf('tour = %i %i\n', m, n);
            imap(m,n) = Var_INoise_each;            
            j = j + block_size;
            n = n + 1;
        end
        i = i + block_size;
        m = m + 1;
    end
    
    %figure, displayMatrixInColorImage(imap);
    
    keySet   = {'totalValue', 'detectionMAP'};
    valueSet = {var(double(raw_detection_map(:))), imap}; 
    output   = containers.Map(keySet, valueSet);
end