function data_i = extract_data(data,scdim,i)
%%
% get the i-th point from the data structure
    switch scdim
        case 2
            data_i = data(:,i);
        case 3
            data_i = data(:,:,i);
        otherwise
            disp('each scenario is a matrix with more than 3 dims, this step could take a long time');
            data_i = aux.extract_dimdata(data, scdim, i);
    end
end