function [finalSM_binary, seedPoints, featureMap, tarImg, finalSM_gray] = TRPCA_KSC_FCM(img, params)
    % 参数初始化
    if nargin < 2
        params = struct();
    end
    if ~isfield(params, 'nSeeds'), params.nSeeds = 10; end
    if ~isfield(params, 'maxIter'), params.maxIter = 50; end
    if ~isfield(params, 'epsilon'), params.epsilon = 1e-5; end
    if ~isfield(params, 'lambda'), params.lambda = 0.85; end
    if ~isfield(params, 'patchSize'), params.patchSize = 50; end
    if ~isfield(params, 'slideStep'), params.slideStep = 40; end
    if ~isfield(params, 'useKernel'), params.useKernel = true; end
    if ~isfield(params, 'kernelType'), params.kernelType = 'rbf'; end
    if ~isfield(params, 'kernelParam'), params.kernelParam = 2.0; end

    % 图像预处理
    I = double(img);
    if size(I,3) == 3
        dataf = rgb2gray(I / 255);
    else
        dataf = I / 255;
    end
    [rows, cols] = size(dataf);

    % 步骤1: TRPCA 稀疏分量分离
    [tarImg] = TRPCA_Separation(dataf, params.lambda, params.patchSize, params.slideStep);
    
    % 自适应重试逻辑
    if sum(tarImg(:)) < 0.01
        [tarImg] = TRPCA_Separation(dataf, params.lambda * 0.6, params.patchSize, params.slideStep);
    end

    % 步骤2: MDPC 密度峰检测
    [seedPoints, ~] = MDPC_Detection(tarImg, params.nSeeds);

    if size(seedPoints, 1) < 1
        finalSM_binary = false(rows, cols);
        finalSM_gray = zeros(rows, cols);
        featureMap = false(rows, cols);
        return;
    end

    % 步骤3: 局部分割与增强
    finalSM = zeros(rows, cols);
    featureMap = false(rows, cols);
    winSize = 11;
    halfWin = floor(winSize / 2);

    for k = 1:size(seedPoints, 1)
        x = seedPoints(k, 1);
        y = seedPoints(k, 2);

        x1 = max(1, x - halfWin);
        x2 = min(cols, x + halfWin);
        y1 = max(1, y - halfWin);
        y2 = min(rows, y + halfWin);

        block_orig = dataf(y1:y2, x1:x2);
        block_tar = tarImg(y1:y2, x1:x2);

        % 补齐边界
        if size(block_orig, 1) < winSize || size(block_orig, 2) < winSize
            padH = winSize - size(block_orig, 1);
            padW = winSize - size(block_orig, 2);
            block_orig = padarray(block_orig, [padH, padW], 'replicate', 'post');
            block_tar = padarray(block_tar, [padH, padW], 'replicate', 'post');
        end

        centerPos = [y - y1 + 1, x - x1 + 1];

        if params.useKernel
            [segBlk, ~] = kifcm_segmentation(block_orig, centerPos, ...
                params.maxIter, params.epsilon, ...
                params.kernelType, params.kernelParam);
        else
            [segBlk, ~] = ifcm_segmentation(block_orig, centerPos, ...
                params.maxIter, params.epsilon);
        end

        [SM_block, F_val] = Target_Enhancement_Fusion(block_orig, block_tar, segBlk);

        % 结果映射回全局
        [h, w] = size(SM_block);
        r_end = min(rows, y1 + h - 1);
        c_end = min(cols, x1 + w - 1);
        h_eff = r_end - y1 + 1;
        w_eff = c_end - x1 + 1;

        % 更新显著图
        finalSM(y1:r_end, x1:c_end) = max(finalSM(y1:r_end, x1:c_end), SM_block(1:h_eff, 1:w_eff));
        
        % 修正点：直接赋值 F_val，MATLAB 会自动处理标量或矩阵映射
        featureMap(y1:r_end, x1:c_end) = featureMap(y1:r_end, x1:c_end) | F_val;
    end

    % 归一化与二值化
    finalSM_gray = mat2gray(finalSM);
    threshold = max(graythresh(finalSM_gray), 0.3);
    finalSM_binary = imbinarize(finalSM_gray, threshold);
end