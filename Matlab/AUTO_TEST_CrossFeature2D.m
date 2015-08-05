function output = AUTO_TEST_CrossFeature2D (ROOT_TEST_DIR_PATH, block_size)
    %ROOT_TEST_DIR_PATH = 'G:\[GitHub]\forgery_detection\AccuracyTest';

    %set up; specify parameters
    FILE_LIST_ORIGINAL = dir(strcat(ROOT_TEST_DIR_PATH, '\TECH_COMBINE_TEST1\original\*.jpg'));
    PATH_ORIGINAL = strcat(ROOT_TEST_DIR_PATH, '\TECH_COMBINE_TEST1\original\');
    PATH_OUTPUT   = strcat(ROOT_TEST_DIR_PATH, '\TECH_COMBINE_TEST1\output\');
    
    for i = 1:length(FILE_LIST_ORIGINAL)
        if (size(strfind(FILE_LIST_ORIGINAL(i).name, '_re.jpg')) == 0)
            src_path = strcat(PATH_ORIGINAL, FILE_LIST_ORIGINAL(i).name);
            OUTPUT_FILE_PREFIX = strcat(PATH_OUTPUT, int2str(i));

            nmap = getNMAP(src_path, block_size, 1, 1);
            imap = getIMAP(src_path, block_size, 1, 1);
            qmap = getQMAP(src_path, block_size, 1, 1);

            %NMAP X IMAP
            P = [nmap('totalValue') imap('totalValue') 0];
            NMAPxIMAP = CrossFeature2D(nmap('detectionMAP'), imap('detectionMAP'), P);
            displayMatrixInColorImage(NMAPxIMAP);
            saveas(gcf,strcat(OUTPUT_FILE_PREFIX, '_NMAPxIMAP'),'jpg');  

            %NMAP X QMAP
            P = [nmap('totalValue') qmap('totalValue') 0];
            NMAPxQMAP = CrossFeature2D(nmap('detectionMAP'), qmap('detectionMAP'), P);
            displayMatrixInColorImage(NMAPxQMAP);
            saveas(gcf,strcat(OUTPUT_FILE_PREFIX, '_NMAPxQMAP'),'jpg'); 

            %IMAP X QMAP
            P = [imap('totalValue') qmap('totalValue') 0];
            IMAPxQMAP = CrossFeature2D(imap('detectionMAP'), qmap('detectionMAP'), P);
            displayMatrixInColorImage(IMAPxQMAP);
            saveas(gcf,strcat(OUTPUT_FILE_PREFIX, '_IMAPxQMAP'),'jpg'); 
            
            
            nmap_no_quantize = getNMAP(src_path, block_size, 0, 0);
            imap_no_quantize = getIMAP(src_path, block_size, 0, 0);
            qmap_no_quantize = getQMAP(src_path, block_size, 0, 0);
            
            %NMAP
            displayMatrixInColorImage(nmap_no_quantize);
            saveas(gcf,strcat(OUTPUT_FILE_PREFIX, '_NMAP'),'jpg');
            
            %IMAP
            displayMatrixInColorImage(imap_no_quantize);
            saveas(gcf,strcat(OUTPUT_FILE_PREFIX, '_IMAP'),'jpg');
            
            %QMAP
            displayMatrixInColorImage(qmap_no_quantize);
            saveas(gcf,strcat(OUTPUT_FILE_PREFIX, '_QMAP'),'jpg');
            
            
            %create final conclusion image
            figure('name','Summary');
            subplot(3,3,1), subimage(imread(strcat(PATH_ORIGINAL, FILE_LIST_ORIGINAL(i).name)));	axis off; axis tight;           title('original');
            subplot(3,3,2), subimage(imread(strcat(OUTPUT_FILE_PREFIX, '_NMAPxIMAP.jpg')));         axis off; axis tight;           title('nmap x imap');
            subplot(3,3,3), subimage(imread(strcat(OUTPUT_FILE_PREFIX, '_NMAPxQMAP.jpg')));         axis off; axis tight;           title('nmap x qmap');
            subplot(3,3,4), subimage(imread(strcat(OUTPUT_FILE_PREFIX, '_IMAPxQMAP.jpg')));         axis off; axis tight;           title('imap x qmap');
            subplot(3,3,5), subimage(imread(strcat(OUTPUT_FILE_PREFIX, '_NMAP.jpg')));              axis off; axis tight;           title('nmap');
            subplot(3,3,6), subimage(imread(strcat(OUTPUT_FILE_PREFIX, '_IMAP.jpg')));              axis off; axis tight;           title('imap');
            subplot(3,3,7), subimage(imread(strcat(OUTPUT_FILE_PREFIX, '_IMAP.jpg')));              axis off; axis tight;           title('qmap');
            saveas(gcf,strcat(OUTPUT_FILE_PREFIX, '_summary'),'jpg');
            close all;
        end
    end
end