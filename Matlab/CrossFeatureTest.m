
function output = CrossFeatureTest (img_path, resaved_img_path, block_size, q_multi_factor)
    kmap = getKurtosisMap(img_path, block_size); % for each blocks
    nmap = getNoiseEstimationMap(img_path, block_size); % for each blocks
    
    qmapImg = getQuatizationNoiseMap(img_path, resaved_img_path, q_multi_factor); % for entire images
    imapImg = InterpolateDetection(img_path); % for entire image
    
    qmap = getBlockQuatizationNoiseVarianceMap(qmapImg, block_size);
    imap = getBlockInterpolateDetectionVarianceMap(imapImg, block_size);
    
    
    %- compute pricipal vector of the whole image --
    IMG = rgb2gray(imread(img_path));
    Noise_all = NoiseEstimate(IMG);
    Kurtosis_all = mean(kurtosis(double(IMG)));
    
    %compute variance for qmap and imap
    var_q_all = var(double(qmapImg(:)));
    var_i_all = var(double(imapImg(:)));
    
    %Principal_vect = [Noise_all Kurtosis_all 0];
    Principal_vect = [var_q_all var_i_all 0];
    %-----------------------------------------------
    
    [w h] = size(kmap);
    output = zeros(w,h);
    for i = 1:w
        for j = 1:h
         
         %V.   construct vector of results
         %vect = [nmap(i,j) kmap(i,j) 0];
         vect = [imap(i,j) qmap(i,j) 0];
         
         %VI.  do cross product
         out_vect = cross(vect, Principal_vect);
         output(i,j) = out_vect(1,3);
        end
    end
    output_vector = output(:);
    
    %malfunction due to NaN value within the output matrix
    %figure, plot(FFT_MAT(output));
    
    %figure, bar3(output);
    %figure, surf(output);
    %figure, plot(output_vector); % output in sequence signal
    figure, displayMatrixInColorImage(output);
    %figure, imshow(output);
    %figure, displayMatrixInColorImage(nmap);
    %figure, displayMatrixInColorImage(kmap);
    figure, imshow(rgb2gray(qmapImg));
    figure, imshow(imapImg);
    figure, displayMatrixInColorImage(imapImg);
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