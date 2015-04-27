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
            
            %create final conclusion image
            figure('name','Summary');
            subplot(3,3,1), subimage(imread(strcat(PATH_ORIGINAL, T1_ORIGINAL(i).name)));	axis off; axis tight;           title('original');
            subplot(3,3,2), subimage(imread(strcat(FILE_NAME_PREFIX, '_q.jpg')));           axis off; axis tight;           title('qmap');
            subplot(3,3,3), subimage(imread(strcat(FILE_NAME_PREFIX, '_n.jpg')));           axis off; axis tight;           title('nmap');
            subplot(3,3,4), subimage(imread(strcat(FILE_NAME_PREFIX, '_cross_q_CbCr.jpg')));	axis off; axis tight;       title('cross Q CbCr');
            subplot(3,3,5), subimage(imread(strcat(FILE_NAME_PREFIX, '_cross_q_YCr.jpg')));     axis off; axis tight;       title('cross Q YCr');
            subplot(3,3,6), subimage(imread(strcat(FILE_NAME_PREFIX, '_cross_q_YCb.jpg')));     axis off; axis tight;       title('cross Q YCb');
            subplot(3,3,7), subimage(imread(strcat(FILE_NAME_PREFIX, '_cross_n_CbCr.jpg')));	axis off; axis tight;       title('cross N CbCr');
            subplot(3,3,8), subimage(imread(strcat(FILE_NAME_PREFIX, '_cross_n_YCr.jpg'))); 	axis off; axis tight;       title('cross N YCr');
            subplot(3,3,9), subimage(imread(strcat(FILE_NAME_PREFIX, '_cross_n_YCb.jpg')));     axis off; axis tight;       title('cross N YCb');
            saveas(gcf,strcat(FILE_NAME_PREFIX, '_sum'),'jpg');
            close all;
        end
    else
        %Abort: Do nothing
    end
    
    fprintf('\n### END_TEST_AUTO_T1 ###\n');
end