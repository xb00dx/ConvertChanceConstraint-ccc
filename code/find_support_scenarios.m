function [support_scenarios, sc_indices] = find_support_scenarios(constr_scenario, constr_det, objective, scenarios, ops)
%%FIND_SUPPORT_SCENARIOS find support scenarios for a scenario probken
%   [SUPPORT_SCENARIOS, SC_INDICES] = FIND_SUPPORT_SCENARIOS(CONSTR_SCENARIO, CONSTR_DET, OBJECTIVE, scenarios, OPS)
%
%   returning a RESULTS struct and SUCCESS flag.
%
%   Inputs (some are optional):
%       INPUTS : explain inputs
%
%   Outputs (some are optional):
%       OUTPUTS ： 
%
%   Calling syntax options:
%       [OUTPUTS] = FUNCTION(INPUTS)
%
%   Examples:
%       [outputs] = function(inputs)
%   ConvertChanceConstraint (CCC)
%   Copyright (c) 2018-2019
%   by X.Geng
%
%   This file is part of CCC.
%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See https://github.com/xb00dx/ConvertChanceConstraint-ccc for more info.
%   Last Edited: July.26.2019

scdim = ndims(scenarios);
N = size(scenarios,scdim);

if length(constr_scenario) ~= N
    error(['#scenario=',num2str(N),' but #scenario-constraint=',num2str(length(constr_scenario)), ': size of scenario constraints not consistant with scenario number']);
end
if ~isfield(ops,'yalmipopt')
    disp('No YALMIP-Option in ops, setting yalmipopt=[]');
    ops.yalmipopt = [];
end
if ~isfield(ops,'type')
    disp('No TYPE in ops, setting ops.type=convex');
    ops.type = 'convex';
end

constr_scenario0 = constr_scenario;

% solve the problem for the first time 
status = optimize([constr_det; constr_scenario0], objective, ops.yalmipopt);
% assert( status.if)
obj0 = value(objective);
support_scenario_candidates = [];
for i = 1:N
    mu = dual( constr_scenario0(i) );
    if ~all(~isnan(mu)) 
        error('NaN dual variable values');
    end
    if norm( mu, inf ) > 0
        support_scenario_candidates = [support_scenario_candidates i];
    end
end
disp(length(support_scenario_candidates));
%% Using Definition for convex problems:
% removal changes the optimal solution
tic;
switch lower(ops.type)
    case 'convex'
        sc_indices = [];
        
        for idx = 1:length(support_scenario_candidates)
            if ops.verbose
                disp(['Solving ',num2str(idx),' out of ',num2str(length(support_scenario_candidates)),' scenario problems.'])
            end
            objectivei = objective;
            constr_scenarioi = constr_scenario;
            constr_scenarioi(support_scenario_candidates(idx)) = [];
            status = optimize([constr_det, constr_scenarioi], objectivei, ops.yalmipopt);
            % assert( status.if)
            obji = value(objectivei);
            assert( (obji-obj0) <= 1e-4 );
            if (obj0 - obji) >= 1e-4 
                sc_indices = [sc_indices; support_scenario_candidates(idx)];
            end
            clear objectivei; clear constr_scenarioi;
        end
        support_scenarios = aux.extract_dimdata(scenarios, scdim, sc_indices);    
    case 'non-convex'
      error('not implemented yet');
    otherwise
        error('problem not convex or non-convex!');
end
t_sc = toc;
disp([num2str(t_sc),' seconds to find support scenarios']);

disp('double checking the correctness of results');
status = optimize([constr_det, constr_scenario(sc_indices)], objective);
assert( abs(value(objective)-obj0) <= 1e-4 );
disp('correct');

end

