clear; close all; 
clc;

disp('begin to solve the problem');
opt_yalmip = sdpsettings('usex0',1);

%% Overall settings
using_optimizer = 0; 
nMC = 10;
ops.beta = 10^(-3);
% distribution = 'gaussian';
distribution = 'beta';
% casepath = '../testcase/Case5Simons/';
% casename = 'ex_case3sc';
casename = 'ex_case24_ieee_rts';
% casename = 'ex_case30';
% casename = 'case57';
% casename = 'ex_case118';

using_cluster = 'none';
% using_cluster = 'terra';

switch using_cluster
    case 'none'
        % datapath = ['~/Documents/gdrive/CCC-Working/Data/',casename,'/'];
        % resultpath = ['~/Documents/gdrive/CCC-Working/Results/',casename,'/'];

        datapath = ['~/Documents/gdrive/Results-cc-DCOPF/data/',casename,'/',distribution,'/'];
        resultpath = ['~/Documents/gdrive/Results-cc-DCOPF/results/',casename,'/',distribution,'/'];
    case 'terra'
        disp('on terra cluster');
        % addpath('../code/'  );
        addpath( genpath('/scratch/user/xbgeng/Libraries/') );
        addpath('/scratch/user/xbgeng/Github/ConvertChanceConstraint-ccc/code/');
        addpath('/sw/eb/sw/CPLEX/12.6.3-GCCcore-6.3.0/cplex/matlab/x86-64_linux/');

        datapath = ['/scratch/user/xbgeng/gdrive/Results-cc-DCOPF/data/',casename,'/',distribution,'/'];
        resultpath = ['/scratch/user/xbgeng/gdrive/Results-cc-DCOPF/results/',casename,'/',distribution,'/'];
    otherwise
        error('no such cluster option');
end

yalmip('clear');

if have_fcn('gurobi')
    disp('have gurobi');
    opt_yalmip = sdpsettings(opt_yalmip,'solver','gurobi','verbose',2);
    opt_yalmip.gurobi.BarConvTol = 1e-4;
    opt_yalmip.gurobi.BarQCPConvTol = 1e-4;
    opt_yalmip.gurobi.FeasibilityTol = 1e-4;
%     opt_yalmip.gurobi.MIPGap = 10^(-6);
%     opt_yalmip.gurobi.MIPGap = 10^(-3);
    opt_yalmip.gurobi.MIPGap = 10^(-2);
elseif have_fcn('cplex')
    disp('have cplex');
    opt_yalmip = sdpsettings(opt_yalmip,'solver','cplex','verbose',2);
else
    error('no available solver');
end


mpc = loadcase(casename);

%% Extract information from the MPC structure
const = ex_extract_ccDCOPF(mpc);

%% Settings for CCC
% epsilons_all = [0.01:0.01:0.05];
% epsilons_all = 0;
% epsilons_all = [0.01:0.01:0.1];
% epsilons_all = [0.2:0.1:0.4];

% epsilons_all = [0.01:0.01:0.1];
% epsilons_all = [0.1:(-0.01):0.01];
% epsilons_all = [0.09:0.01:0.1, 0.2:0.1:0.3];
% epsilons_all = [0.3:0.1:0.9];
epsilons_all = 0.07;
for ieps = 1:length(epsilons_all)

% common settings
ops.epsilon = epsilons_all(ieps); 
% ops.epsilon = 0;

ops.verbose = 1;

% ops.method = 'scenario approach';
% ops.method = 'convex approximation';
% ops.method = 'sample average approximation';
ops.method = 'robust counterpart';

switch ops.method
    case 'scenario approach'
        ops.beta = 1/100;
        % ops.type = 'non-convex';
        ops.type = 'convex';
    case 'convex approximation'
        ops.type = 'markov bound';
    case 'sample average approximation'  
        ops.type = 'sampling and discarding';
        PMAX = 9;
        ops.M = sum(mpc.gen(:,PMAX))*5;
    case 'robust counterpart'
        assert( using_optimizer == 0 ); % not compatiable with YALMIP optimizer 
%         ops.support.center = zeros(const.nload,1);
%         ops.support.radius =...
%             norminv( (1-ops.epsilon/2)*ones(const.nload,1),zeros(const.nload,1),const.d_hat*0.05);
%       ops.type = 'box';
        ops.type = 'ball';
%         ops.type = 'ball-box';
%         ops.type = 'budget';
        disp(ops.type);
%         opt_yalmip = sdpsettings(opt_yalmip,'robust.lplp','duality');
%        ops.reformulate = 'automatic'; % using the auto robust optimization of YALMIP
%        ops.reformulate = 'manual'; % manually derive equivalent robust counterparts
    otherwise
        error('unknown method');
end
disp([ops.method,': ',ops.type]);


%% Formulate the cc-DCOPF Problem
% Detailed Formulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% min_{g,s,eta} c(g) + c(s)
% s.t. sum(g) = sum(d) - sum(s)
%      f_l <= Hg*g - Hd*(d_hat-s) <= f_u
%      g_l <= g <= g_u
%      sum(eta) = 1
%      Prob( f_l <= Hg*[g+sum(d_err)*eta] - Hd*(d_hat+d_err-s) <= f_u,
%           and g_l <= g+sum(d_err)*eta <= g_u) >= 1 - epsilon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Formulate the Problem Using YALMIP and CCC
g = sdpvar(const.ngen,1,'full'); % generation
s = sdpvar(const.nload,1,'full'); % load shed
eta = sdpvar(const.ngen,1,'full'); % affine corrective control policy
d_err = sdpvar(const.nload,1,'full'); % forecast errors of loads

objective = g'*const.Q*g + const.c_g'*g + const.c_s*sum(s) + const.c_g'*eta;

constr_det = [sum(g) == sum(const.d_hat) - sum(s);
    const.f_l <= const.Hg*g - const.Hd*(const.d_hat-s) <= const.f_u;
    const.g_l <= g <= const.g_u;
     zeros(const.nload,1) <= s <= const.d_hat;
%     s == 0;
    sum(eta) == 1;
    zeros(const.ngen,1) <= eta <= ones(const.ngen,1)];
constr_inner = [const.g_l <= g + sum(d_err)*eta <= const.g_u;
    const.f_l <= const.Hg*(g+ sum(d_err)*eta) - const.Hd*(const.d_hat+d_err-s) <= const.f_u];
% d_err_data = mvnrnd(zeros(nload,1), 0.05*diag(d_hat),N)';

% Train and Test Data 
% eps_test = zeros(nMC, 14);


% N_trains = [10:10:100];
% N_trains = 2^11;
% N_trains = [10:10:100,2.^(7:11)];
N_trains = 2^11;
% N_trains = 100;
% N_trains = [200:100:500];
% N_trains = 2.^(11:13);
for iN = 1:length(N_trains)
N_train = N_trains(iN);
N_test = 10^4;
testdata = load([datapath,casename,'-testdata-N=',num2str(N_test),'.mat'] );
 
%% Solve the Problem
% If running the problem many times (i.e. Monte-Carlo Simulation)
% with the same dataset size N
% it is suggested to use optimizer of YALMIP (Monte_Carlo == 1)
% If solving the problem only once (Monte-Carlo = 0)
% It is much faster to use optimize() of YALMIP

if strcmp(ops.method,'sample average approximation')
    if strcmp(ops.type, 'sampling and discarding')
        % no load shedding
        k = get_scenario_num_removed(N_train, 2*(const.ngen-1), ops.epsilon, ops.beta);
        % with load shedding
%         k = get_scenario_num_removed(N_train, 2*(const.ngen-1)+const.nload, ops.epsilon, ops.beta);
        disp([num2str(k), ' scenarios can be removed from ' num2str(N_train), ' scenarios.']);
        ops.alpha = k/N_train;
%         elseif strcmp(ops.type, '')
        if k < 0
            continue;
        end
    else
        error('unknown type for sample average approximation');
    end
    ops.pi = ones(N_train,1)/N_train;
end

if using_optimizer
    % Convert Chance Constraint
    d_err_data = sdpvar(const.nload,N_train,'full');
    constr_prob = prob(constr_inner,d_err, ops.epsilon,d_err_data,ops);
    % Introducing auxilary variable to use optimizer
    sdpvar aux_obj;
    constr_obj = [objective <= aux_obj];
    dec_vars = {aux_obj,g,s,eta};
    ind.obj = 1; ind.g = 2; ind.s = 3; ind.eta = 4;
    ccDCOPF = optimizer([constr_det; constr_prob; constr_obj],...
        aux_obj,opt_yalmip, d_err_data, dec_vars);
    save([resultpath,casename,'-',ops.method,'-N=',num2str(N_train),'-workspace.mat']);
    for iMC = 1:nMC
        disp(['Monte-Carlo Simulation ', num2str(iMC)]);
        traindata = load([datapath,casename,...
            '-traindata-N=',num2str(N_train),'-iMC=',num2str(iMC),'.mat'] );
        tic;
        [sol,errorcode,yalmipinfo,~,problem_para0] = ccDCOPF{traindata.d_err};
        t_solve = toc;
        disp(yalmipinfo);
        assert(errorcode == 0); % for successfully solved
        % assign values to the sdpvar variables to check violation prob
        assign(aux_obj, sol{ind.obj}); assign(g, sol{ind.g});
        assign(s, sol{ind.s}); assign(eta, sol{ind.eta});
        eps_ofs = check_violation_prob(constr_inner, d_err,testdata.d_err, ops);
        disp(['out of sample violation probability is: ', num2str(eps_ofs)]);
        % save results
        results(iMC).epsilon = ops.epsilon;
        results(iMC).N_train = N_train;
        results(iMC).N_test = N_test;
        results(iMC).eps_ofs = eps_ofs;
        results(iMC).obj = sol{ind.obj};
        results(iMC).g = sol{ind.g};
        results(iMC).s = sol{ind.s};
        results(iMC).eta = sol{ind.eta};
        results(iMC).solvetime = t_solve;
        results(iMC).ops = ops;
%         eps_test(iMC,iN) = eps_ofs;
        switch ops.method
            case 'scenario approach'
            disp('finding suppport scenarios');
            [support_scenarios, sc_indices] = get_support_scenarios(problem_para0,...
                traindata.d_err, ind.obj, sol, ops);
            results(iMC).support_scenarios = support_scenarios;
            results(iMC).sc_indices = sc_indices;
            disp(sc_indices);
            case 'sample average approximation'
                [~,violated] = check_violation_prob(constr_inner, d_err,traindata.d_err, ops);
                results(iMC).violated = violated;
                disp([num2str(length(violated.indices)),' scenarios being violated']);
            otherwise
                error('no such method');
        end
    end
    if strcmp(ops.method, 'scenario approach')
        save([resultpath,casename,'-',ops.method,'-results-N=',num2str(N_train),'.mat'],'results');
    else
        save([resultpath,casename,'-',ops.method,'-',ops.type,...
            '-results-N=',num2str(N_train),'-epsilon=',num2str(ops.epsilon),'.mat'],'results');
    end
    clear results;
else
    for iMC = 1:nMC
        disp(['Monte-Carlo Simulation ', num2str(iMC)]);
        traindata = load([datapath,casename,...
            '-traindata-N=',num2str(N_train),'-iMC=',num2str(iMC),'.mat'] );
        d_err_data = traindata.d_err;
        constr_prob = prob(constr_inner,d_err, ops.epsilon, d_err_data,ops);
        sol = optimize([constr_det; constr_prob],...
            objective,opt_yalmip);    
        disp(sol.info);
        % assert(sol.problem == 0);
        if sol.problem ~= 0
            results(iMC).obj = NaN;
            continue;
        %     msgbox('no feasible');
        end
        eps_ofs = check_violation_prob(constr_inner, d_err, testdata.d_err, ops);
        disp(['out of sample violation probability is: ', num2str(eps_ofs)]);
        disp(ops.epsilon);
        if strcmp(ops.method, 'sample average approximation')
            [~,violated] = check_violation_prob(constr_inner, d_err, traindata.d_err, ops);
            results(iMC).violated = violated;
            disp([num2str(length(violated.indices)),' scenarios being violated']);
        end
        % save results
        results(iMC).epsilon = ops.epsilon;
        results(iMC).N_train = N_train;
        results(iMC).N_test = N_test;
        results(iMC).eps_ofs = eps_ofs;
        results(iMC).obj = value(objective);
        results(iMC).g = value(g);
        results(iMC).s = value(s);
        results(iMC).eta = value(eta);
        results(iMC).solvetime = sol.solvertime;
        results(iMC).ops = ops;
%       eps_test(iMC,iN) = eps_ofs;
    end
    if strcmp(ops.method, 'scenario approach')
        save([resultpath,casename,'-',ops.method,'-results-N=',num2str(N_train),'.mat'],'results');
    else
        save([resultpath,casename,'-',ops.method,'-',ops.type,...
            '-results-N=',num2str(N_train),'-epsilon=',num2str(ops.epsilon),'.mat'],'results');
    end    
end

end

end

