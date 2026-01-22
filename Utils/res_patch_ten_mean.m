function recImg = res_patch_ten_mean(patchTen, imgSize, patchSize, slideStep)
    if isscalar(imgSize)
        imgHei = imgSize;
        imgWid = imgSize;
    else
        imgHei = imgSize(1);
        imgWid = imgSize(2);
    end
    
    rowStarts = 1:slideStep:(imgHei - patchSize + 1);
    if rowStarts(end) ~= (imgHei - patchSize + 1)
        rowStarts = [rowStarts, imgHei - patchSize + 1];
    end
    
    colStarts = 1:slideStep:(imgWid - patchSize + 1);
    if colStarts(end) ~= (imgWid - patchSize + 1)
        colStarts = [colStarts, imgWid - patchSize + 1];
    end
    
    accImg = zeros(imgHei, imgWid, 'like', patchTen);
    weiImg = zeros(imgHei, imgWid, 'like', patchTen);
    
    k = 0;
    onesPatch = ones(patchSize, patchSize, 'like', patchTen);
    
    for col = colStarts
        for row = rowStarts
            k = k + 1;
            rowEnd = row + patchSize - 1;
            colEnd = col + patchSize - 1;
            accImg(row:rowEnd, col:colEnd) = accImg(row:rowEnd, col:colEnd) + patchTen(:, :, k);
            weiImg(row:rowEnd, col:colEnd) = weiImg(row:rowEnd, col:colEnd) + onesPatch;
        end
    end
    
    weiImg(weiImg == 0) = 1;
    recImg = accImg ./ weiImg;
end