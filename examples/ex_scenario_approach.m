clear; clc; close all;
%% Optimization problem
% min_{x,r} r
% s.t.  prob_w( x-r <= w <= x+r ) >= 1 - epsilon

%% Settings
ops.method = 'scenario approach';
% ops.type = 'non-convex';
ops.type = 'convex';
ops.verbose = 1;
yalmip_opt = sdpsettings('usex0',1);
% ops.type = 'non-convex';
% number of scenarios
N = 100;
wdata = normrnd(0,1,[1,N]);
wtest = normrnd(0,1,[1,10^2]);

%% Problem formulation
sdpvar x r w
wsa = sdpvar(1,N,'full'); % scenario approach
obj = r;
constr = [x-r <= w <= x+r];
% constr = [x-r <= w <= x+r; x-2*r <= w <= x+2*r];

%% Solving chance constrained problem using Scenario Approach
% Usage 1: build an optimization model for one time, solve it for one time
chance_constr_opt = prob(constr, w, 0.05, wdata, ops);
sol1 = optimize( sdpvar(chance_constr_opt) >= 0, obj);
% sol1 = optimize( chance_constr_opt, obj);
xopt1 = value(x); ropt1 = value(r);
disp(xopt1); disp(ropt1);
disp(['Objective value: ', num2str(value(obj))]);
% evaulate out-of-sample violation probability
eps_ofs1 = check_violation_prob(constr, w, wtest, ops);
disp(['Out of Sample violation prob 1: ', num2str(eps_ofs1)]);


% 
% %% Solving chance constrained problem using Scenario Approach
% % Usage 2: build a parametrized model for one time, solve it many times with differnet parameters
% chance_constr_para =  prob(constr,w,0.05, wsa, ops);
% sdpvar aux_obj; % aux variable to get the objective function
% constr_obj = [r <= aux_obj];
% dec_var = {aux_obj,x,r};
% obj_ind = 1; % aux_obj is the first variable in dec_var
% x_ind = 2; r_ind = 3;
% problem_para = optimizer([chance_constr_para constr_obj], aux_obj, yalmip_opt, wsa, dec_var);
% [sol2,~,~,~,problem_para0] = problem_para{ wdata  };
% xopt2 = sol2{x_ind}; ropt2 = sol2{r_ind};
% disp('Optimal Solutions:');
% disp(xopt2); disp(ropt2);
% disp(['Obejctive value: ', num2str(sol2{obj_ind})]);
% % evaulate out-of-sample violation probability
% assign([x r],[xopt2 ropt2]);
% eps_ofs2 = check_violation_prob(constr,w,wtest);
% disp(['Out of Sample violation prob 2: ', num2str(eps_ofs2)]);
% % find support scenarios
% [support_scenarios, sc_indices] = get_support_scenarios(problem_para0, wdata, obj_ind, sol2, ops);

figure;
scatter(wdata, zeros(1,N),'ko'), hold on
scatter(support_scenarios, zeros(1,size(support_scenarios,2)),'m+'), hold on,
return;
plot([xopt1-ropt1,xopt1],[1,1],'r-x'), hold on,
plot([xopt1,xopt1+ropt1],[1,1],'r-x'), hold on,
plot([xopt2-ropt2,xopt2],[-1,-1],'b-x'), hold on,
plot([xopt2,xopt2+ropt2],[-1,-1],'b-x'), hold on,
grid on,
hold off