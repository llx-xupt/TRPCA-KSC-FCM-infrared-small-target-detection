function Eny = diff_element(dim, direction)
    d = length(dim);
    e = ones(1, d);
    element1 = ones(e);
    element2 = -1 * ones(e);
    kernel = cat(direction, element1, element2);
    Eny = abs(psf2otf(kernel, dim)).^2;
end