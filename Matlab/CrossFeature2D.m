% In this class, we perform a 2d cross product on
% the results, r1 and r2, from two existing techniques.

function output = CrossFeature2D (r1, r2, principal_vect)
    [w1 h1] = size(r1);
    [w2 h2] = size(r2);
    
    w = w1;
    if w2 < w1
        w = w2;
    end
    
    h = h1;
    if h2 < h1
        h = h2;
    end
    
    output = zeros(w,h);
    for i = 1:w
        for j = 1:h
         %V. construct regional vectors
         reg_vect = [r1(i,j) r2(i,j) 0];
         
         %VI.  do cross product
         out_vect = cross(principal_vect, reg_vect);
         output(i,j) = out_vect(1,3);
        end
    end
    
    %form the output
    %output = output; % meaning less instruction
    output = abs(output);
    
    %display output
    %figure('name','R1'), displayMatrixInColorImage(r1);
    %figure('name','R2'), displayMatrixInColorImage(r2);
    
    %figure('name','Proposed Algorithm: SURF'), surf(output);
    %figure('name','Proposed Algorithm'); displayMatrixInColorImage(output);
end

function displayMatrixInColorImage (img_matrix)
    mat = img_matrix;
    imagesc(mat);             %# Create a colored plot of the matrix values
    %colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                              %# black and lower values are white)
end