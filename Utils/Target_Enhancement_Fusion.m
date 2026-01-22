function [SM, F] = Target_Enhancement_Fusion(block_orig, block_tar, segmentedBlock)
    max_target_size = 80;
    
    cc = bwconncomp(segmentedBlock);
    F = double(cc.NumObjects == 1);
    
    if F == 1
        object_size = length(cc.PixelIdxList{1});
        if object_size > max_target_size
            F = 0;
        end
    end
    
    if F == 1
        block_orig = double(block_orig);
        block_tar = double(block_tar);
        
        protectedRegion = false(size(block_orig));
        protectedRegion(2:end-1, 2:end-1) = true;
        
        targetMask = segmentedBlock & protectedRegion;
        if any(targetMask(:))
            gT_orig = max(block_orig(targetMask));
            gT_tar = max(block_tar(targetMask));
            gT = 0.6 * gT_orig + 0.4 * gT_tar;
        else
            gT = 0;
        end
        
        backgroundRegion = protectedRegion & ~segmentedBlock;
        if any(backgroundRegion(:))
            gB_orig = max(block_orig(backgroundRegion));
            gB_tar = mean(block_tar(backgroundRegion));
            gB = 0.7 * gB_orig + 0.3 * gB_tar;
        else
            gB = 0;
        end
        
        dTB = gT - gB;
        
        if dTB > 0
            normBlock_orig = mat2gray(block_orig);
            normBlock_tar = mat2gray(block_tar);
            SM = zeros(size(block_orig));
            SM(targetMask) = (0.5 * normBlock_orig(targetMask) + ...
                             0.5 * normBlock_tar(targetMask)) * dTB * 3;
        else
            SM = zeros(size(block_orig));
        end
    else
        SM = zeros(size(block_orig));
    end
end