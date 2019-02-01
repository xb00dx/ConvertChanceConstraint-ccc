function datout = extract_dimdata(datin, dim, idx)
%%EXTRACT_DIMDATA
% e.g. A = ones(10,5,4,3)
% dim = 3, idx = 2
% return A(:,:,2,:)

    inds = repmat({':'},1,ndims(datin));
    inds{dim} = idx;
    datout = datin(inds{:});
end