function OUT = DFT_IMG(RGB)

    A   = dftmtx(RGB);
    Ai = conj(A)/n; %invert dft
    %OUT = fftshift(A);               % frequency scaling
    OUT = A;
    figure; imshow(OUT);
    figure; imshow(Ai);
end