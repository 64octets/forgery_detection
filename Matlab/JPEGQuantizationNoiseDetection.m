%JPEG Quantization Noise Estimation
function detection_map = JPEGQuantizationNoiseDetection (path)
    
    clc;

    %read image
    img = rgb2gray(imread(path));
    
    % JPEG compression
    jpegcompression(img,'D:\Master Courses\Thesis\TestResource\test_compressed.mat');
    % JPEG decompression
    Irec = jpegrestoration('D:\Master Courses\Thesis\TestResource\test_compressed.mat');
    
    % System performances
    [CR,BPP,PSNR,MSE,SNR] = systemperformances(img,Irec,'D:\Master Courses\Thesis\TestResource\test_compressed.mat');

    % Plotting
    figure,subplot(1,2,1),imshow(img),title('Original image'),...
        subplot(1,2,2),imshow(Irec),title('Decompressed image');

    disp('Compression ratio:');
    disp(CR);
    disp('Bits per pixel:');
    disp(BPP);
    disp('Peak signal to noise ratio:');
    disp(PSNR);
    disp('Mean squared error:');
    disp(MSE);
    disp('Signal to noise ratio');
    disp(SNR);

    output = imsubtract(img, Irec);
    %{
    for i = 1:numel(output)
        if(output(i) > 0)
            output(i) = 255;
        end
    end
    %}
    output = output * 255;
    output = im2bw(output);
    %output = imcomplement(output);
    figure, imshow(output);
    detection_map = output;
end
