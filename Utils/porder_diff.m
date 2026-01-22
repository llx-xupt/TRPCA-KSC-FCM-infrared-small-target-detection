function DX = porder_diff(X, direction)
    dim = size(X);
    idx = repmat({':'}, 1, ndims(X));
    idx_first = idx; idx_first{direction} = 1;
    idx_end = idx; idx_end{direction} = dim(direction);
    slice = X(idx_first{:}) - X(idx_end{:});
    DX = diff(X, 1, direction);
    DX = cat(direction, DX, slice);
end