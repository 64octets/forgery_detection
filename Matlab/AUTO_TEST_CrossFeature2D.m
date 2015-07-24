function output = AUTO_TEST_CrossFeature2D (img_path, block_size)

    r1 = getNMAP(img_path, block_size);
    r2 = getIMAP(img_path, block_size);
    
    P = [r1('totalValue') r2('totalValue') 0];
    CrossFeature2D(r1('detectionMAP'), r2('detectionMAP'), P);
end