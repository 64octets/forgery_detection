function output = TEST_BLIND_NOISE_AUTO (img_path, block_size)
    IMG = rgb2gray(imread(img_path));

    img_noise = NoiseEstimate(IMG);
    nmap = getNoiseEstimationMap(img_path, block_size); % for each blocks
    figure, displayMatrixInColorImage(nmap);
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