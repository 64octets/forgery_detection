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

    if length(T1_ORIGINAL) == length(T1_RESAVED)
        for i = 1:length(T1_ORIGINAL)
            FILE_NAME_PREFIX = strcat(PATH_OUTPUT, int2str(i));
            
            %Test on CrossFeature(JPEGQuantization)
            out1_qCbCr = CrossFeatureTest_chroma_AUTO(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor, 1, 1);
            out1_qYCr = CrossFeatureTest_chroma_AUTO(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor, 1, 2);
            out1_qYCb = CrossFeatureTest_chroma_AUTO(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor, 1, 3);
            imagesc(out1_qCbCr);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_cross_q_CbCr'),'jpg');
            imagesc(out1_qYCr);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_cross_q_YCr'),'jpg');
            imagesc(out1_qYCb);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_cross_q_YCb'),'jpg');
            
            %Test on JPEGQuantization
            out2 = TEST_QUANTIZE_AUTO (strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor);
            imagesc(out2);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_q'),'jpg');
            
            %Test on CrossFeature(NoiseEstimation)
            out3_nCbCr = CrossFeatureTest_chroma_AUTO(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor, 2, 1);
            out3_nYCr = CrossFeatureTest_chroma_AUTO(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor, 2, 2);
            out3_nYCb = CrossFeatureTest_chroma_AUTO(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), strcat(PATH_RESAVED, T1_RESAVED(i).name), block_size, q_multi_factor, 2, 3);
            imagesc(out3_nCbCr);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_cross_n_CbCr'),'jpg');
            imagesc(out3_nYCr);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_cross_n_YCr'),'jpg');
            imagesc(out3_nYCb);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_cross_n_YCb'),'jpg');
            
            %Test on NoiseEstimation
            out4 = TEST_BLIND_NOISE_AUTO (strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name), block_size);
            imagesc(out4);
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_n'),'jpg');
        end
    else
        %Abort: Do nothing
    end
    
    fprintf('\n### END_TEST_AUTO_T1 ###\n');
end