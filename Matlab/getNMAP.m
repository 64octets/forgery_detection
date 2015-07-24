% this function responsible for creating map of noise estimated 
% from EACH IMAGE BLOCK.

function output = getNMAP (img_path, block_size)
    % Flags & Tags
    ENABLE_NOISE_LEVEL = 1;

    %I.   read image
    IMG = rgb2gray(imread(img_path));

    %fprintf('getNMAP on img size: (%i, %i)', size(IMG, 1), size(IMG, 2));
    
    IMG = getNoiseMap(IMG);  %test
    
    %II. estimate noise on each blocks
    [img_w img_h] = size(IMG);
    i = 1;
    nmap = zeros(int8(img_w/block_size), int8(img_h/block_size));
    m = 1;
    while (i + block_size <= img_w)
        j = 1;
        n = 1;
        while (j + block_size <= img_h)
            current_block = IMG((i:i+block_size),(j:j+block_size));
            %fprintf('noise each = %i       %i\n', var(double(current_block(:))), Noise_each);
            if ENABLE_NOISE_LEVEL == 1
                Noise_each = getNoiseLevel(current_block);
                nmap(m,n) = Noise_each;
            else
                nmap(m,n) = var(double(current_block(:)));
            end
            
            j = j + block_size;
            n = n + 1;
        end
        i = i + block_size;
        m = m + 1;
    end
    
    %set key & value mapping
    keySet   = {'totalValue', 'detectionMAP'};
    if ENABLE_NOISE_LEVEL == 1
        valueSet = {getNoiseLevel(IMG), nmap}; 
    else
        valueSet = {var(double(IMG(:))), nmap}; 
    end
    
    output   = containers.Map(keySet, valueSet);
end

function NoiseLv = getNoiseLevel(I)
	[H W]=size(I);
	I=double(I);

	% compute sum of absolute values of Laplacian
	M=[1 -2 1; -2 4 -2; 1 -2 1];
	NoiseLv = sum(sum(abs(conv2(I, M))));

	% scale sigma with proposed coefficients
	NoiseLv = NoiseLv * sqrt(0.5*pi)./(6*(W-2)*(H-2));
end

function NoiseMap = getNoiseMap(grayscale_img)
    I = double(grayscale_img);
    M = [1 -2 1; -2 4 -2; 1 -2 1];
    NoiseMap = abs(conv2(I, M));
end