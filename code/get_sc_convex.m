function sc_indices = get_sc_convex(om, wdata, scdim, obj_index, sol0)
    obj0 = sol0{ obj_index };
    N = size(wdata, scdim);
    sc_indices = [];
    for i = 1:N
        if i == 1
            data_replace = aux.extract_dimdata(wdata, scdim, N);
        else
            data_replace = aux.extract_dimdata(wdata, scdim, i-1);
        end
        wdata_rmv = aux.replace_dimdata(wdata, scdim, i, data_replace);
        [soli,status,~,~,~] = om{ wdata_rmv };
        assert(status == 0);
        obji = soli{ obj_index };
        % might be a bug here
        % with this assertion, less scenarios could have higher obj values
        if obj0 >=0 
            assert(obji <= obj0*(1+10^(-4)) );            
        else 
            assert(obji >= obj0*(1+10^(-4)) );
        end
        
        if abs(obji - obj0) >= abs(obj0)*10^(-4)
            sc_indices = [sc_indices; i];
        end

    end
end