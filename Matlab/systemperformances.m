function [CR,BPP,PSNR,MSE,SNR]=systemperformances(I0,I1,compressed_data_file)
% function [CR,BPP,PSNR,MSE,SNR]=systemperformances(I0,I1,compressed_data_file)
% Performances of compression algorithm
% INPUT:
% I0:                   original image
% I1:                   decompressed image
% compressed_data_file: file name of cmpressed data
% OUTPUT:
% Ires:                 reconstructed image
% CR:                   compression ratio
% BPP:                  bits per pixel
% PSNR:                 peak signal to noise ratio
% MSE:                  mean squared error
% SNR:                  signal to noise ratio
%
% Luigi Rosa
% Via Centrale 35
% 67042 Civita Di Bagno
% L'Aquila - ITALY
% mobile +39 3207214179
% email luigi.rosa@tiscali.it
% website http://www.advancedsourcecode.com
%

I0 = double(I0);
I1 = double(I1);

if ndims(I0)==3
    size0 = 3*8*size(I0,1)*size(I0,2);
else
    size0 = 1*8*size(I0,1)*size(I0,2);    
end
file1 = dir(compressed_data_file);
size1 = 8*file1.bytes;

% Compression ratio
CR = size0/size1;
% Bits per pixel
BPP = size1/(size(I0,1)*size(I0,2));

% Difference signal
Id = (I0-I1);

signal = sum(sum(I0(:).^2));
noise  = sum(sum(Id(:).^2));

SNR    = 10*log10(signal/noise);
%disp('SNR Signal to Noise Ratio');
%disp(SNR);

MSE  = noise/numel(I0);
peak = max(I0(:));
PSNR = 10*log10(peak^2/MSE);
%disp('PSNR Peak Signal to Noise Ratio');
%disp(PSNR);

