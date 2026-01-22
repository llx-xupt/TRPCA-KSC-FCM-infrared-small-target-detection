function [X] = prox_pstnn(Y, N, mu_inv_tau)
    [n1, n2, n3] = size(Y);
    X = zeros(n1, n2, n3);
    Yf = fft(Y, [], 3);
    tau = mu_inv_tau;
    min_n1_n2 = min(n1, n2);
    
    % 第一个切片
    [U, S, V] = svd(Yf(:, :, 1), 'econ');
    diagS = diag(S);
    
    if N >= min_n1_n2
        threshS = max(diagS - tau, 0);
        X(:, :, 1) = U * diag(threshS) * V';
    else
        [desS, sIdx] = sort(diagS, 'descend');
        [desU, desV] = deal(U(:, sIdx), V(:, sIdx));
        [U1, diagS1, V1] = deal(desU(:, 1:N), desS(1:N), desV(:, 1:N));
        [U2, diagS2, V2] = deal(desU(:, N+1:end), desS(N+1:end), desV(:, N+1:end));
        threshS2 = max(diagS2 - tau, 0);
        X(:, :, 1) = U1 * diag(diagS1) * V1' + U2 * diag(threshS2) * V2';
    end
    
    % 其他切片
    halfn3 = round(n3 / 2);
    for i = 2:halfn3
        [U, S, V] = svd(Yf(:, :, i), 'econ');
        diagS = diag(S);
        
        if N >= min_n1_n2
            threshS = max(diagS - tau, 0);
            X(:, :, i) = U * diag(threshS) * V';
        else
            [desS, sIdx] = sort(diagS, 'descend');
            [desU, desV] = deal(U(:, sIdx), V(:, sIdx));
            [U1, diagS1, V1] = deal(desU(:, 1:N), desS(1:N), desV(:, 1:N));
            [U2, diagS2, V2] = deal(desU(:, N+1:end), desS(N+1:end), desV(:, N+1:end));
            threshS2 = max(diagS2 - tau, 0);
            X(:, :, i) = U1 * diag(diagS1) * V1' + U2 * diag(threshS2) * V2';
        end
        X(:, :, n3 + 2 - i) = conj(X(:, :, i));
    end
    
    if mod(n3, 2) == 0
        i = halfn3 + 1;
        [U, S, V] = svd(Yf(:, :, i), 'econ');
        diagS = diag(S);
        
        if N >= min_n1_n2
            threshS = max(diagS - tau, 0);
            X(:, :, i) = U * diag(threshS) * V';
        else
            [desS, sIdx] = sort(diagS, 'descend');
            [desU, desV] = deal(U(:, sIdx), V(:, sIdx));
            [U1, diagS1, V1] = deal(desU(:, 1:N), desS(1:N), desV(:, 1:N));
            [U2, diagS2, V2] = deal(desU(:, N+1:end), desS(N+1:end), desV(:, N+1:end));
            threshS2 = max(diagS2 - tau, 0);
            X(:, :, i) = U1 * diag(diagS1) * V1' + U2 * diag(threshS2) * V2';
        end
    end
    
    X = ifft(X, [], 3);
    X = real(X);
end