function OUT = FFT_IMG(RGB)

    %RGB = imread(path);
    %I   = rgb2gray(RGB);             % convert the image to grey 

    %A   = fft2(double(I));           % compute FFT of the grey image
    
    A   = fft2(double(RGB));
    OUT = fftshift(A);               % frequency scaling
    %imshow(OUT);
end