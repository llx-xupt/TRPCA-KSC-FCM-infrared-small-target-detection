function [seeds, gamma] = MDPC_Detection(M, n)
    [rows, cols] = size(M);
    num_pixels = rows * cols;
    
    edgeWidth = max(3, round(0.02 * min(rows, cols)));
    M_suppressed = M;
    M_suppressed(1:edgeWidth, :) = 0;
    M_suppressed(end-edgeWidth+1:end, :) = 0;
    M_suppressed(:, 1:edgeWidth) = 0;
    M_suppressed(:, end-edgeWidth+1:end) = 0;
    
    [X, Y] = meshgrid(1:cols, 1:rows);
    points = [X(:), Y(:)];
    densities = M_suppressed(:);
    
    max_distance = sqrt((rows - 1)^2 + (cols - 1)^2);
    
    [sorted_densities, sorted_idx] = sort(densities, 'descend');
    sorted_points = points(sorted_idx, :);
    
    delta = zeros(num_pixels, 1);
    delta(1) = max_distance;
    
    for i = 2:num_pixels
        if sorted_densities(i) > 0
            higher_idx = find(sorted_densities(1:i-1) > sorted_densities(i));
            if ~isempty(higher_idx)
                dists = sqrt((sorted_points(i, 1) - sorted_points(higher_idx, 1)).^2 + ...
                           (sorted_points(i, 2) - sorted_points(higher_idx, 2)).^2);
                delta(i) = min(dists);
            else
                delta(i) = max_distance;
            end
        else
            delta(i) = 0;
        end
    end
    
    gamma = sorted_densities .* delta;
    valid_idx = find(gamma > 0);
    n_actual = min(n, length(valid_idx));
    
    [~, gamma_sorted_idx] = sort(gamma, 'descend');
    seeds = sorted_points(gamma_sorted_idx(1:n_actual), :);
end
