function ss_indices = get_sc_nonconvex(om, wdata, scdim, obj_index, sol0)
    % remove scenarios one by one, solve the problem repeatedly
    % rmv_ind: indices of scenarios that are removed
    % rem_ind: indices of scenarios that remain in sc
    % rep_ind: replace rmv_ind scenarios with copies of rep_ind 
    
    % solve the problem for the first time;
%     [sol0,status0,~,~,om] = om_init{ wdata };
%     disp(yalmiperror(status0)); assert( status0 == 0 );
    obj0 = sol0{ obj_index };
    
    N = size(wdata, scdim);
    rmv_ind = []; rem_ind = (1:N)';
    removed = 1; 
    while ( ~isempty(rem_ind) && (removed == 1) )     
        removed = 0;
        for i = N:(-1):1
            rem_ind = setdiff((1:N)', rmv_ind);
            if any( rmv_ind == i)
                continue;
            end
            rep_ind = setdiff(rem_ind, i);
            if isempty(rep_ind) 
                break;
            end
            wrepl = aux.extract_dimdata(wdata, scdim, rep_ind(1));
            wrepls = wrepl;
            for irmv = 1:length(rmv_ind)
                wrepls = cat(scdim, wrepls, wrepl);
            end
            wtest = aux.replace_dimdata(wdata, scdim, [rmv_ind;i], wrepls);

            [soli,statusi,~,~,~] = om{ wtest }; 
            assert(statusi == 0);
            obji = soli{ obj_index };
            if abs(obji-obj0) < 1e-3
                rmv_ind = [rmv_ind; i];
                removed = 1;
            end
            clear wtest; clear wrepls; clear wrepl;
%             close all;
        end
    end
    rem_ind = setdiff((1:N)', rmv_ind);
    wrepl = aux.extract_dimdata(wdata, scdim, rem_ind(end));
    wrepls = [];
    for irmv = 1:length(rmv_ind)
        wrepls = cat(scdim, wrepls, wrepl);
    end
    wtest = aux.replace_dimdata(wdata, scdim, rmv_ind, wrepls);  
    [sol1,status1,~,~,~] = om{ wtest }; 
    assert( status1 == 0 );
    obj1 = sol1{ obj_index };
    disp(obj1); disp(obj0);
    ss_indices = setdiff((1:N)', rmv_ind);
    
    n_ss = length(ss_indices);
    assert(n_ss >= 1); 
    ind_test = [ss_indices; repmat(ss_indices(1), N-n_ss, 1)];
    wdata_test = aux.extract_dimdata(wdata, scdim, ind_test);
    [sol_test,status_test,~,~,~] = om{ wdata_test };
    assert( status_test == 0 );
    obj_test = sol_test{ obj_index };
    if abs( obj_test - obj0 ) / abs(obj0) > 1e-6 
        disp('need more calculations for non-convex problems');
        disp([num2str(obj_test),'<',num2str(obj0)]);
        error('need to figure out a smart algorithm for min-support sets');
    else
        disp('results look correct');
    end
end