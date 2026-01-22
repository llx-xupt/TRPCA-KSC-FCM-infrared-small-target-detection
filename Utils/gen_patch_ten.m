function patchTen = gen_patch_ten(img, patchSize, slideStep)
    [imgHei, imgWid] = size(img);
    
    rowStarts = 1:slideStep:(imgHei - patchSize + 1);
    if rowStarts(end) ~= (imgHei - patchSize + 1)
        rowStarts = [rowStarts, imgHei - patchSize + 1];
    end
    
    colStarts = 1:slideStep:(imgWid - patchSize + 1);
    if colStarts(end) ~= (imgWid - patchSize + 1)
        colStarts = [colStarts, imgWid - patchSize + 1];
    end
    
    rowPatchNum = length(rowStarts);
    colPatchNum = length(colStarts);
    patchTen = zeros(patchSize, patchSize, rowPatchNum * colPatchNum, 'like', img);
    
    k = 0;
    for col = colStarts
        for row = rowStarts
            k = k + 1;
            patchTen(:, :, k) = img(row:row + patchSize - 1, col:col + patchSize - 1);
        end
    end
end