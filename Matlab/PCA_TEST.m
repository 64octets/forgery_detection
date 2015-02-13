%{
function output = PCA_TEST (img_path, block_size, enable_output)
    %I.   read image
    IMG = rgb2gray(imread(img_path));

    %II.  split images into arrays of blocks
    blocks = mat2cell(IMG,block_size*ones(1,size(IMG,1)/block_size),block_size*ones(1,size(IMG,2)/block_size));

    %III.  estimate noise + entropy on whole image
    Noise_all = NoiseEstimate(IMG);
    Kurtosis_all = kurtosis(IMG);
    Principal_vect = [Noise_all Kurtosis_all 0];
    
    fprintf('principal vector %i   %i\n', Noise_all, Entropy_all);
    
    %IV. estimate noise on each blocks
    [w h] = size(blocks);
    output = zeros(w,h);
    for i = 1:w
        for j = 1:h
         Noise_each = NoiseEstimate(blocks{i,j});  
         Kurtosis_each = kurtosis(blocks{i,j});
         
         %V.   construct vector of results
         vect = [Noise_each Kurtosis_each 0];
         
         %VI.  do cross product
         out_vect = cross(vect, Principal_vect);
         output(i,j) = out_vect(1,3);
        end
    end
    
    %find max and min of the output
    max = output(1,1);
    min = output(1,1);
    for i = 1:w
        for j = 1:h
           if output(i,j) > max
            max = output(i,j);
           end
           if output(i,j) < min
            min = output(i,j);
           end
        end
    end

    if enable_output == 1
        fprintf('max %i\n', max);
        fprintf('min %i\n', min);
    end
end
%}

function output = PCA_TEST (img_path, block_size)
    kmap = getKurtosisMap(img_path, block_size);
    nmap = getNoiseEstimationMap(img_path, block_size);
    
    IMG = rgb2gray(imread(img_path));
    Noise_all = NoiseEstimate(IMG);
    Kurtosis_all = mean(kurtosis(double(IMG)));
    Principal_vect = [Noise_all Kurtosis_all 0];
    
    [w h] = size(kmap);
    output = zeros(w,h);
    for i = 1:w
        for j = 1:h
         
         %V.   construct vector of results
         vect = [nmap(i,j) kmap(i,j) 0];
         
         %VI.  do cross product
         out_vect = cross(vect, Principal_vect);
         output(i,j) = out_vect(1,3);
        end
    end
    output_vector = output(:);
    
    %malfunction due to NaN value within the output matrix
    %figure, plot(FFT_MAT(output));
    
    figure, bar3(output);
    figure, surf(output);
    figure, plot(output_vector);
    figure, displayMatrixInColorImage(output);
    figure, displayMatrixInColorImage(nmap);
    figure, displayMatrixInColorImage(kmap);
end

function NoiseLv = NoiseEstimate(I)
	[H W]=size(I);
	I=double(I);

	% compute sum of absolute values of Laplacian
	M=[1 -2 1; -2 4 -2; 1 -2 1];
	NoiseLv = sum(sum(abs(conv2(I, M))));

	% scale sigma with proposed coefficients
	NoiseLv = NoiseLv * sqrt(0.5*pi)./(6*(W-2)*(H-2));
end