function [support_scenarios, sc_indices] = find_support_scenarios(constraints, objective, wdata, ops)

% om_para: parametrized optimization model (optimizer)
% (wrong) wdata: nw-by-N numerical matrix, scenarios for w
% obj_index: index of the aux obj variable t (i.e. objective <= t)
% om_para: already solved once, and supplying initial guesses

scdim = ndims(wdata);
N = size(wdata,scdim);

assert( isfield(constraints, 'prob') ); 
constr_prob = [sdpvar(constraints.prob) >= 0];
assert(size(constr_prob,2) == N); 

constr_det = [];
if isfield(constraints, 'det')
    det_constr = constraints.det;
end

% solve the problem for the first time 
status = optimize([constr_det, constr_prob], objective);
% assert( status.if)

%% Using Definition for convex problems:
% removal changes the optimal solution
tic;
switch lower(ops.type)
    case 'convex'
        sc_indices = get_sc_convex(om_para, wdata, scdim, obj_index, sol0);
        support_scenarios = aux.extract_dimdata(wdata, scdim, sc_indices);
        
    case 'non-convex'
%         sc_indices = get_sc_convex(om_para, wdata, scdim, obj_index, obj0);
        sc_indices = get_sc_nonconvex(om_para, wdata, scdim, obj_index, sol0);
        n_sc = length(sc_indices);
        assert(n_sc >= 1); 
        ind_test = [sc_indices; repmat(sc_indices(1), N-n_sc, 1)];
        wdata_test = aux.extract_dimdata(wdata, scdim, ind_test);
        [sol_test, status_test,~,~,~] = om_para{ wdata_test };
        assert( status_test == 0 );
        obj_test = sol_test{ obj_index };
        if obj_test < (obj0-10^(-6))
            disp('need more calculations for non-convex problems');
            disp([num2str(obj_test),'<',num2str(obj0)]);
            error('need to figure out a smart algorithm for min-support sets');
        elseif obj_test > (obj0+10^(-6))
            error('obj value increases with less scenarios!');
        else
            support_scenarios = aux.extract_dimdata(wdata, scdim, sc_indices);
        end
    otherwise
        error('problem not convex or non-convex!');
end
t_sc = toc;
disp([num2str(t_sc),' seconds to find support scenarios']);
end

