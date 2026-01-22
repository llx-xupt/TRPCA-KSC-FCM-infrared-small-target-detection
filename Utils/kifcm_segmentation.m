function [segmentedBlock, iterations] = kifcm_segmentation(block, center, maxIter, epsilon, kernelType, kernelParam)
    
    if nargin < 3, maxIter = 50; end
    if nargin < 4, epsilon = 1e-5; end
    if nargin < 5, kernelType = 'rbf'; end
    if nargin < 6
        switch kernelType
            case 'rbf'
                kernelParam = 2.0;
            case 'poly'
                kernelParam = 3;
            otherwise
                kernelParam = 1.0;
        end
    end
    
    c = 2;
    q = 2;
    S = 22;
    
    [rows, cols] = size(block);
    N = rows * cols;
    block = double(block);
    blockVec = block(:);
    
    [X, Y] = meshgrid(1:cols, 1:rows);
    distMat = sqrt((X - center(2)).^2 + (Y - center(1)).^2) + eps;
    w = (S ./ distMat).^(1/3);
    w = w(:);
    
    switch lower(kernelType)
        case 'rbf'
            kernelFunc = @(x, y) exp(-sum((x - y).^2, 2) / (2 * kernelParam^2));
        case 'poly'
            kernelFunc = @(x, y) (x .* y + 1).^kernelParam;
        case 'linear'
            kernelFunc = @(x, y) x .* y;
        otherwise
            error('不支持的核函数类型: %s', kernelType);
    end
    
    targetCenter = block(center(1), center(2));
    bgCenter = mean(blockVec);
    v = [targetCenter; bgCenter];
    
    U = zeros(N, c);
    distToCenter = sqrt((X-center(2)).^2 + (Y-center(1)).^2) + eps;
    U(:,1) = 1./(1 + distToCenter(:));
    U(:,2) = 1 - U(:,1);
    U = U ./ sum(U, 2);
    
    % 核矩阵对角线
    K_diag = ones(N, 1);
    
    % 迭代优化
    prevJ = inf;
    iterations = 0;
    converged = false;
    
    while ~converged && iterations < maxIter
        iterations = iterations + 1;
        
        % 更新聚类中心
        for k = 1:c
            weightedMembership = (w .* U(:,k)).^q;
            numerator = sum(weightedMembership .* blockVec);
            denominator = sum(weightedMembership) + eps;
            v(k) = numerator / denominator;
        end
        
        % 核距离计算
        D_kernel = zeros(N, c);
        for k = 1:c
            K_xv = kernelFunc(blockVec, v(k));
            K_vv = kernelFunc(v(k), v(k));
            D_kernel(:, k) = K_diag - 2*K_xv + K_vv;
        end
        D_kernel = max(D_kernel, eps);
        
        % 更新隶属度
        U_new = zeros(N, c);
        for k = 1:c
            denom = 0;
            for m = 1:c
                ratio = (w.^q .* D_kernel(:,k)) ./ (w.^q .* D_kernel(:,m) + eps);
                denom = denom + ratio.^(1/(q-1));
            end
            U_new(:,k) = 1 ./ (denom + eps);
        end
        U_new = U_new ./ (sum(U_new, 2) + eps);
        
        % 计算目标函数
        J = 0;
        for k = 1:c
            weighted_membership = (w .* U_new(:,k)).^q;
            J = J + sum(weighted_membership .* D_kernel(:,k));
        end
        
        % 收敛判断
        if abs(prevJ - J) / (abs(prevJ) + eps) < epsilon
            converged = true;
        end
        
        prevJ = J;
        U = U_new;
    end
    
    % 生成分割结果
    [~, labels] = max(U, [], 2);
    segmentedBlock = reshape(labels == 1, rows, cols);
end