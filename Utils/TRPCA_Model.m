function [X, E, err, iter] = TRPCA_Model(M, opts)
    dim = size(M);
    lambda = 0.85 / sqrt(prod(dim) / max(dim(1), dim(2)));
    mu = 0.15;
    N = 1;
    directions = 1:2;
    tol = 7e-3;
    max_iter = 500;
    rho = 1.05;
    max_mu = 10;
    
    if exist('opts', 'var') && ~isempty(opts)
        if isfield(opts, 'tol'), tol = opts.tol; end
        if isfield(opts, 'max_iter'), max_iter = opts.max_iter; end
        if isfield(opts, 'rho'), rho = opts.rho; end
        if isfield(opts, 'max_mu'), max_mu = opts.max_mu; end
        if isfield(opts, 'N'), N = opts.N; end
        if isfield(opts, 'mu'), mu = opts.mu; end
        if isfield(opts, 'lambda')
            lambda = opts.lambda / sqrt(prod(dim) / max(dim(1), dim(2)));
        end
    end
    
    n = length(directions);
    X = zeros(dim);
    E = zeros(dim);
    Lambda = zeros(dim);
    
    for i = 1:n
        index = directions(i);
        G{index} = porder_diff(X, index);
        Gamma{index} = zeros(dim);
    end
    
    T_fft = zeros(dim);
    for i = 1:n
        Eny = diff_element(dim, directions(i));
        T_fft = T_fft + Eny;
    end
    
    iter = 0;
    Ek = E;
    
    while iter < max_iter
        iter = iter + 1;
        
        H = zeros(dim);
        for i = 1:n
            index = directions(i);
            H = H + porder_diff_T(mu * G{index} - Gamma{index}, index);
        end
        X = real(ifftn(fftn(mu * (M - Ek) + Lambda + H) ./ (mu * (1 + T_fft))));
        
        for i = 1:n
            index = directions(i);
            G{index} = prox_pstnn(porder_diff(X, index) + Gamma{index} / mu, ...
                                  N, 1 / (n * mu));
        end
        
        E = prox_l1(M - X + Lambda / mu, lambda / mu);
        
        dY = M - X - E;
        err = norm(dY(:)) / norm(M(:));
        
        if iter > 1 && err < tol
            break;
        end
        
        Lambda = Lambda + mu * dY;
        for i = 1:n
            index = directions(i);
            Gamma{index} = Gamma{index} + mu * (porder_diff(X, index) - G{index});
        end
        mu = min(rho * mu, max_mu);
        Ek = E;
    end
end