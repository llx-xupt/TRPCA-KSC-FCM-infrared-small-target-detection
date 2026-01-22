function [tarImg] = TRPCA_Separation(dataf, lambda, patchSize, slideStep)
    opts.lambda = lambda;
    tenImg = double(gen_patch_ten(dataf, patchSize, slideStep));
    [~, E, ~, ~] = TRPCA_Model(tenImg, opts);
    tarImg = res_patch_ten_mean(E, size(dataf), patchSize, slideStep);
    tarImg(tarImg < 0) = 0;
    tarImg = mat2gray(tarImg);
end
