function output = TEST_AUTO_T1(ROOT_TEST_DIR_PATH)
    fprintf('\n### START_TEST_AUTO_T1 ###\n');
    %ROOT_TEST_DIR_PATH = 'E:\[GitHub]\forgery_detection\AccuracyTest';
    
    %I - get file list
    T1_ORIGINAL = dir(strcat(ROOT_TEST_DIR_PATH, '\T1\original\*.jpg'));
    T1_RESAVED  = dir(strcat(ROOT_TEST_DIR_PATH, '\T1\resaved\*.jpg'));
    PATH_ORIGINAL = strcat(ROOT_TEST_DIR_PATH, '\T1\original\');
    PATH_RESAVED  = strcat(ROOT_TEST_DIR_PATH, '\T1\resaved\');
    PATH_OUTPUT   = strcat(ROOT_TEST_DIR_PATH, '\T1\output\');
    
    block_size = 3;
    q_multi_factor = 50;
    COMBINATION = 2; % Y + Cr Channels

    if length(T1_ORIGINAL) == length(T1_RESAVED)
        for i = 1:length(T1_ORIGINAL)
            FILE_NAME_PREFIX = strcat(PATH_OUTPUT, int2str(i));
            
            %Test on CrossFeature(JPEGQuantization)
            
            %Test on JPEGQuantization
            
            %Test on CrossFeature(NoiseEstimation)
            out3_CbCr = CrossFeatureTest_chroma_AUTO(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor, 2, 1);
            out3_YCr = CrossFeatureTest_chroma_AUTO(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor, 2, 2);
            out3_YCb = CrossFeatureTest_chroma_AUTO(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor, 2, 3);
            imagesc(out3_CbCr);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_cross_noise_CbCr'),'jpg');
            imagesc(out3_YCr);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_cross_noise_YCr'),'jpg');
            imagesc(out3_YCb);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_cross_noise_YCb'),'jpg');
            
            %Test on NoiseEstimation
            out4 = TEST_BLIND_NOISE_AUTO (strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), block_size);
            imagesc(out4);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_noise'),'jpg');
        end
    else
        %Abort: Do nothing
    end
    
    fprintf('\n### END_TEST_AUTO_T1 ###\n');
end