function [support_scenarios, sc_indices] = find_support_scenarios(constraints, objective, wdata, ops)

% om_para: parametrized optimization model (optimizer)
% (wrong) wdata: nw-by-N numerical matrix, scenarios for w
% obj_index: index of the aux obj variable t (i.e. objective <= t)
% om_para: already solved once, and supplying initial guesses

scdim = ndims(wdata);
N = size(wdata,scdim);

assert( isfield(constraints, 'prob') ); 
constr_prob = constraints.prob;
assert(length(constr_prob) == N); 
constr_prob0 = constr_prob;

constr_det = [];
if isfield(constraints, 'det')
    constr_det = constraints.det;
end

% solve the problem for the first time 
status = optimize([constr_det; constr_prob0], objective, ops.yalmipopt);
% assert( status.if)
obj0 = value(objective);
support_scenario_candidates = [];
for i = 1:N
    if norm( dual( constr_prob0(i) ), inf ) > 0
        support_scenario_candidates = [support_scenario_candidates i];
    end
end

%% Using Definition for convex problems:
% removal changes the optimal solution
tic;
switch lower(ops.type)
    case 'convex'
        sc_indices = [];
        for idx = 1:length(support_scenario_candidates)
            objectivei = objective;
            constr_probi = constr_prob;
            constr_probi(support_scenario_candidates(idx)) = [];
            status = optimize([constr_det, constr_probi], objectivei,ops.yalmipopt);
            % assert( status.if)
            obji = value(objectivei);
            assert( (obji-obj0) <= 1e-4 );
            if (obj0 - obji) >= 1e-4 
                sc_indices = [sc_indices; support_scenario_candidates(idx)];
            end
        end
        support_scenarios = aux.extract_dimdata(wdata, scdim, sc_indices);    
    case 'non-convex'
      error('not implemented yet');
    otherwise
        error('problem not convex or non-convex!');
end
t_sc = toc;
disp([num2str(t_sc),' seconds to find support scenarios']);
end

