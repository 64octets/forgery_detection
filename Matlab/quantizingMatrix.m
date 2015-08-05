function output = quantizingMatrix(in_matrix)

    %quantization steps
    QUANTIZE_STEPS = 49; %divide data into 9 + 1 sub-levels

    [w h]  = size(in_matrix);
    output = zeros(w,h);
    
    max_val = max(in_matrix(:));
    min_val = min(in_matrix(:));
    
    %Quantizing
    range = max_val - min_val;
    ranged_value = zeros(1,QUANTIZE_STEPS);
    
    STEP = double(range / QUANTIZE_STEPS); %3.5556
    
    for i = 1:w
        for j = 1:h
            step_val = min_val;
            output(i,j) = step_val;
            
            for k = 1:QUANTIZE_STEPS
                step_val = step_val + STEP;
                if (in_matrix(i,j) > step_val)
                    output(i,j) = step_val;
                else
                    break;
                end
            end
            
        end
    end
end