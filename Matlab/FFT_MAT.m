function OUT = FFT_MAT(MATRIX)
    %A   = fft2(double(MATRIX));
    %OUT = fftshift(A);               % frequency scaling
    
    OUT = fft2(MATRIX);
end