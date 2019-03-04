clear; clc; close all

using_cluster = 0;
if using_cluster == 1
    disp('on ada cluster');
    addpath('../code/'  );
    addpath( genpath('/scratch/user/xbgeng/libraries/') );
    % addpath('~/github-tamu/ccc/code/');
%     addpath('/general/software/x86_64/easybuild/software/CPLEX/12.6.3-GCCcore-6.3.0/cplex/matlab/x86-64_linux');
elseif using_cluster == 2
    disp('on terra cluster');
    addpath('../code/'  );
    addpath( genpath('/scratch/user/xbgeng/Libraries/') );
%     addpath('/sw/eb/sw/CPLEX/12.6.3-GCCcore-6.4.0/cplex/matlab/x86-64_linux/');
end
yalmip('clear');

casename = 'ex_case3sc';
mpc = loadcase(casename);
const = ex_extract_ccDCOPF(mpc);

datapath = ['~/Documents/gdrive/CCC-Working/Data/',casename,'/'];
resultpath = ['~/Documents/gdrive/CCC-Working/Results/',casename,'/'];
ops.verbose = 0;

%% For
g = sdpvar(const.ngen,1,'full'); % generation
eta = sdpvar(const.ngen,1,'full'); % affine corrective control policy
d_err = sdpvar(const.nload,1,'full'); % forecast errors of loads
objective = g'*const.Q*g + const.c_g'*g;
constr_inner = [const.g_l <= g + sum(d_err)*eta <= const.g_u;
    const.f_l <= const.Hg*(g+ sum(d_err)*eta) - const.Hd*(const.d_hat+d_err) <= const.f_u];

N = 10^3;
n_g1 = 2^8; n_eta1 = 2^8;
testdata = load([datapath,casename,'-testdata-N=',num2str(N),'.mat'] );

% u_g1 = const.g_u(1); l_g1 = const.g_l(1);
% n_g1 = 2^9; n_eta1 = 2^9;
% u_g1 = 340; l_g1 = 240;
% n_g1 = 3^4; n_eta1 = 3^4;
u_g1 = 290; l_g1 = 270;
d_g1 = (u_g1-l_g1)/(n_g1-1);
d_eta1 = (1-0)/(n_eta1-1);
g1 = l_g1:d_g1:u_g1;
eta1 = 0:d_eta1:1;
[g1_grid, eta1_grid] = meshgrid(eta1, g1);
epsilon = zeros(n_g1, n_eta1);
tic;
for i_g1 = 1:n_g1
    disp(i_g1);
    for i_eta1 = 1:n_eta1
        assign(g, [g1(i_g1); sum(const.d_hat) - g1(i_g1) ]);
        assign(eta, [eta1(i_eta1); 1 - eta1(i_eta1)]);
        epsilon(i_g1, i_eta1) = check_violation_prob(constr_inner, d_err, testdata.d_err, ops);
    end
end
toc
grid.epsilon = epsilon;
grid.g1_grid = g1_grid; grid.eta1_grid = eta1_grid;
grid.g1 = g1; grid.eta1 = eta1;
save([resultpath,casename,'-feasibility-grid-N=',num2str(N),'-',num2str(n_g1*n_eta1),'points.mat'],'grid');
surf(g1_grid, eta1_grid, epsilon)
