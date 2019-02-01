function [prob_constr, data_constr] = prob(F, xi, epsilon, data, ops)
%PROB   convert chance constraint to solvable form
% prob( F(x,xi) <= 0 ) >= 1-epsilon
% F
% xi
% epsilon
% data: could be numerical matrices or sdpvar matrices
% ops: settings
%   ops.approacch
%   ops??
% 
% Author X. Geng
% $Id: prob.m,v 0.1 2018-09-25 xbgeng Exp $

% things to do
% check if data has field: 'N', 'dim'
% new assertion using scenarios

% checking input datastruct
if ~isfield(ops, 'verbose')
    ops.verbose = 1;
end


disp('Converting Chance Constraint');
tic;
% Vectorize constraints
F = sdpvar(F);
switch lower(ops.method)
    case 'scenario approach'
        prob_constr = scenario_approach(F, xi, data, ops);
    case 'factor clt'
        % n_xi = length(xi);
        % assert(size(data,1) == n_xi);
        % build factor model $x = \mu + \Lambda f + e$
        if ~exist('ops', 'var') || ~isfield(ops, 'factor')
            ops.factor = [];
        end
        if ~isfield(ops.factor, 'num') 
            ops.factor.num = ceil(n_xi/2); % to be updated 
        end
        % the factor model might be normalized
        [Lambda,psi,T,stats,F] = factoran(data', ops.factor.num,'rotate','none');
        % construct CLT uncertainty set
        varphi = sdpvar(ops.factor.num,1,'full');
        % mu and sigma of factors to be checked
        constr_varphi = robust_clt(epsilon, varphi, zeros(ops.factor.num,1), 1);
        vareps = sdpvar(n_xi,1,'full');
        constr_vareps = robust_clt(epsilon, vareps, zeros(n_xi,1), psi );
        % to be calculated: mu and standarized transform
%         figure;
%         data_norm = normalize(data')';
%         data_fa = Lambda * F';
%         scatter3(data_norm(1,:),data_norm(2,:),data_norm(3,:),'kx'), hold on,
%         scatter3(data_fa(1,:),data_fa(2,:),data_fa(3,:),'ro'), hold on,
        prob_constr = [ xi - mean(data,2) == diag(std(data')) *( Lambda*varphi + vareps ); 
            uncertain(xi);...
            constr_varphi;...
            constr_vareps];
    case 'sample average approximation'
        [prob_constr, data_constr] = sample_average_approximation(F, xi, data, ops);
    case 'convex approximation'
        prob_constr = convex_approximation(F, xi, data, ops);
    case 'robust counterpart'
        prob_constr = robust_counterpart(F, xi, data, ops);
    otherwise
        error('no such option in prob() function.');
end

t_prob = toc;
disp([num2str(t_prob), ' seconds used to convert chance constraint' ]);
end