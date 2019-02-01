function datout = replace_dimdata(datin, dim, idx, datset)
%%SET_DIMDATA
% e.g. A = ones(10,5,4,3)
% dim = 3, idx = 2
% A(:,:,2,:) = datset
    inds = repmat({':'},1,ndims(datin));
    inds{dim} = idx;
    datout = datin;
    datout(inds{:}) = datset;
%     datout = datin(inds{:});
end