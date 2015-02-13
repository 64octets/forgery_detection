function [signals,PC,V] = pca(IMG)
%{
I =imread('D:\Master Courses\Thesis\TestResource\Au_ani_10206.jpg');
I = rgb2gray(I);
%b = im2double(I); 
%imshow(b, []); 
figure, imshow(I);
%}
I = rgb2gray(IMG);

images = im2double(I);
figure, imshow(images);
[M,N] = size(images);

%-----------------------------------------------------------------------

[COEFF, SCORE] = princomp(images);
reconstructed_images = SCORE / COEFF + repmat(mean(images,1), M, 1);

%figure, imshow(reconstructed_images);

for i=50:N
    SCORE(:,i) = zeros(M,1);
end

reconstructed_images_with_reduced_features = SCORE / COEFF + repmat(mean(images,1), M, 1);

figure, imshow(reconstructed_images_with_reduced_features);

%-----------------------------------------------------------------------
%{
data = im2double(I);
data = data-repmat(mean(data,2),1,size(data,2));

% calculate eigenvectors (loadings) W, and eigenvalues of the covariance matrix
    [W, EvalueMatrix] = eig(cov(data'));
    Evalues = diag(EvalueMatrix);

% order by largest eigenvalue
    Evalues = Evalues(end:-1:1);
    W = W(:,end:-1:1); W=W';  
    
first_pc_images = Evalues(1) / W + repmat(mean(images,1), M, 1);
figure, imshow(first_pc_images);
%}
end