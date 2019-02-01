clear; clc; close all;
yalmip('clear');

%% Parameters
% chance constraint
epsilon = 0.05;
Gamma = icdf(makedist('normal'), 1-epsilon/2);

% size
N = 100; nw = 2; nf = 1; d = nw;
% factor model
mu_w = (nw:(-1):1)'; Lambda = (1:nw)';
mu_phi = 0; std_phi = 1;
mu_eps = 0; std_eps = 0.1;
% others
L = 2;
% L = inf;

%% Generate Data for the Factor Model
phi_data = normrnd(mu_phi, std_phi, [1,N]);
eps_data = normrnd(mu_eps, std_eps,[nw,N]);        
wdata = mu_w + Lambda * phi_data + eps_data;

%% Construct Factor Model
% Without learning from data
Lambda_data = Lambda; mu_w_data = mu_w;
mu_phi_data = mu_phi; std_phi_data = std_phi;
mu_eps_data = mu_eps; std_eps_data = std_eps;

% Using Factor Analysis from data

%% Formulate Problem (2 different ways)
x = sdpvar(d,1,'full');
w = sdpvar(nw,1,'full');
sdpvar r;
vareps = sdpvar(nw,1,'full');
varphi = sdpvar(nf,1,'full');

% Factor Model
w = mu_w_data + Lambda_data*varphi + vareps;
constr_ro = [norm(w-x, L) <= r];

% First Formulation
constr_phi1 = [uncertain(varphi);
    -Gamma*sqrt(nw) <= (varphi-mu_phi)' * (1 ./std_phi ) <= Gamma*sqrt(nw);
    -Gamma*std_phi <= varphi-mu_phi <= Gamma*std_phi ];
constr_eps1 = [uncertain(vareps);
    -Gamma*sqrt(nw) <= (vareps-mu_eps)' * (1 ./std_eps ) <= Gamma*sqrt(nw);
    -Gamma*std_eps <= vareps-mu_eps <= Gamma*std_eps ];

% Second Formulation
constr_phi2 = robust_clt(epsilon, varphi, mu_phi_data, std_phi_data);
constr_eps2 = robust_clt(epsilon, vareps, mu_eps_data, std_eps_data);

%% Solve the Problem and Analyze Results
% Solve the First Formulation
optimize([constr_phi1 constr_eps1 constr_ro], r)
sol1.x = value(x); sol1.r = value(r);
disp('optimal x:'); disp( num2str(sol1.x) );
disp('optimal r:'); disp( num2str(sol1.r) );

% Solve the Second Formulation
optimize([constr_phi2 constr_eps2 constr_ro], r)
sol2.x = value(x); sol2.r = value(r);
disp('optimal x:'); disp( num2str(sol2.x) );
disp('optimal r:'); disp( num2str(sol2.r) );

% Checking out-of-sample violation probability
N_test = 10^4;
phi_test = normrnd(mu_phi, std_phi, [1,N_test]);
eps_test = normrnd(mu_eps, std_eps,[nw,N_test]);        
wtest = mu_w + Lambda * phi_test + eps_test;

% Check ofs prob of formulation 1
assign(x, sol1.x); assign(r, sol1.r);
eps_ofs1 = check_violation_prob(constr_ro, w, wtest);
disp(eps_ofs1);

% Check ofs prob of formulation 2
assign(x, sol2.x); assign(r, sol2.r);
eps_ofs2 = check_violation_prob(constr_ro, w, wtest);
disp(eps_ofs2);

% Plot uncertainty set
w_plot = sdpvar(nw,1,'full');
constr_plot = [ w_plot == mu_w + vareps;
    -Gamma*sqrt(nw) <= sum( (vareps-mu_eps)./ std_eps ) <= Gamma*sqrt(nw);    
    -Gamma*std_eps <= vareps <= Gamma*std_eps;
];
