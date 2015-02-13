function hi_out = HIGH_PASS_FILTER_IMG(fft_shift_image, img, radius)

    [M N]=size(img);          % image size
    R = radius;             % filter size parameter 
    X=0:N-1;
    Y=0:M-1;
    
    [X Y] = meshgrid(X,Y);
    Cx=0.5*N;
    Cy=0.5*M;
    Lo=exp(-((X-Cx).^2+(Y-Cy).^2)./(2*R).^2);
    Hi=1-Lo; % High pass filter = 1-low pass filter
    
    %produce high pass filter output
    [h,g] = size(fft_shift_image)
    [a,v] = size(Hi)
    
    K      = fft_shift_image.*Hi;
    K1     = ifftshift(K);
    hi_out = ifft2(K1);

    figure, imshow(K);
    figure, imshow(hi_out);
end