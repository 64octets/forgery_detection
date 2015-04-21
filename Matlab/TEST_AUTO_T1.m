function output = TEST_AUTO_T1
    fprintf('\n### START_TEST_AUTO_T1 ###\n');

    %I - get file list
    T1_ORIGINAL = dir('E:\[GitHub]\forgery_detection\AccuracyTest\T1\original\*.jpg');
    T1_RESAVED  = dir('E:\[GitHub]\forgery_detection\AccuracyTest\T1\resaved\*.jpg');
    PATH_ORIGINAL = 'E:\[GitHub]\forgery_detection\AccuracyTest\T1\original\';
    PATH_RESAVED  = 'E:\[GitHub]\forgery_detection\AccuracyTest\T1\resaved\';
    PATH_OUTPUT   = 'E:\[GitHub]\forgery_detection\AccuracyTest\T1\output\';
    
    block_size = 3;
    q_multi_factor = 50;
    COMBINATION = 2; % Y + Cr Channels

    if length(T1_ORIGINAL) == length(T1_RESAVED)
        for i = 1:length(T1_ORIGINAL)
            FILE_NAME_PREFIX = strcat(PATH_OUTPUT, int2str(i));
            
            %Test on CrossFeature(JPEGQuantization)
            
            %Test on JPEGQuantization
            
            %Test on CrossFeature(NoiseEstimation)
            out3 = CrossFeatureTest_chroma_AUTO(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor, 2, COMBINATION);
            figure;
            imagesc(out3);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_cross_noise'),'jpg');
            
            %Test on NoiseEstimation
        end
    else
        %Abort: Do nothing
    end
    
    fprintf('\n### END_TEST_AUTO_T1 ###\n');
end