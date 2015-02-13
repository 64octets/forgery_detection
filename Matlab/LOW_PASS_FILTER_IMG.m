%FILTERS

function low_out = LOW_PASS_FILTER_IMG(fft_shift_image, img, radius)

    [M N]=size(img);          % image size
    R = radius;             % filter size parameter 
    X=0:N-1;
    Y=0:M-1;
    
    [X Y] = meshgrid(X,Y);
    Cx=0.5*N;
    Cy=0.5*M;
    Lo=exp(-((X-Cx).^2+(Y-Cy).^2)./(2*R).^2);
    
    %produce low pass filter output
    J       = fft_shift_image.*Lo;
    J1      = ifftshift(J);
    low_out = ifft2(J1);
    
    figure, imshow(J);
    %figure, imshow(low_out);
	imshow(abs(low_out),[12 290])
end