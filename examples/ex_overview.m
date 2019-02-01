clear;
%% Optimization problem
% min_{x,r} r
% s.t.  prob_w( x-r <= w <= x+r ) >= 1 - epsilon
% finding the shortest segment (center x, radius r) to cover
% 1-epsilon portion of uncertain variable w

ops.verbos = 1;
%% Settings for ConvertChanceConstraint (CCC)
% scenario approach
ops.method = 'scenario approach'; ops.type = 'convex';
% sample average approximation
ops.method = 'sample average approximation';
ops.type = 'sampling and discarding';
% convex approximation
ops.method = 'convex approximation'; ops.type = 'markov bound';
% robust counterpart
ops.method = 'robust counterpart'; ops.type = 'ball-box';

%% Settings for the Data
N = 100; ops.epsilon = 0.05; ops.beta = 1e-3;
w_data = normrnd(0,1,[1,N]);
%% Problem formulation
sdpvar x r w; obj = r;
inner_constr = [x-r <= w <= x+r];
%% Converting chance constrained problem using CCC
% convert inner_constr to deterministic forms that YALMIP can solve
chance_constr = prob(inner_constr, w, w_data, ops);
%% Solving the Problem
% via YALMIP and specified solver
sol = optimize(chance_constr, obj);
disp('Optimal Solution')
disp(value(x)); disp(value(r));
disp(['Objective value: ', num2str(value(obj))]);

%% Result Analysis
% evaulate out-of-sample violation probability 
wtest = normrnd(0,1,[1,10^4]);
epsilon_empirical = check_violation_prob(inner_constr, w, wtest);
disp(['Out of sample violation probability : ', num2str(epsilon_empirical)]);
