clear; clc; close all;

fig_size = [10,10,800,400];
beta = 10^(-3);

% casename = 'ex_case3sc';
casename = 'ex_case24_ieee_rts';
% resultpath = './ccDCOPF/';
resultpath = '~/Documents/gdrive/Results-cc-DCOPF/results/ex_case24_ieee_rts/beta/';

% resultpath = './temp/';
% method = 'convex approximation';
method = 'scenario approach';

% Ns = [10:10:100,200:100:500];
% Ns = 2.^(4:10);
Ns = [10:10:100,2.^(7:11)];

nMC = 10;
eps = zeros(length(Ns), nMC);
obj = zeros(length(Ns), nMC);
for iN = 1:length(Ns)
    result = load([resultpath,casename,'-',method,'-results-N=',num2str(Ns(iN)),'.mat']);
    for iMC = 1:nMC
        eps(iN, iMC) = result.results(iMC).eps_ofs;
        obj(iN, iMC) = result.results(iMC).obj;
    end
end

eps_pri = zeros(length(Ns), 1);
for iN = 1:length(Ns)
    eps_pri(iN) = get_pre_violation_prob(Ns(iN), 64, beta, 'exact');
%     eps_pri(iN) = get_pre_violation_prob(Ns(iN), 4, beta, 'exact');
end

eps_post = zeros(length(Ns), nMC);
for iN = 1:length(Ns)
    result = load([resultpath,casename,'-',method,'-results-N=',num2str(Ns(iN)),'.mat']);
    for iMC = 1:nMC
%         n_ss = length(result.results(iMC).sc_indices);
        n_ss = 10;
        eps_post(iN, iMC) = get_post_violation_prob(Ns(iN),n_ss,beta);
    end
end

eps_empirical = eps;
save([casename,'-',method,'-results.mat'], 'Ns', 'eps_empirical', 'obj', 'eps_pri', 'eps_post');

% calculate lower bounds
% epsilons = 0.01:0.01:0.1; % case 3
% epsilons = 0.01:0.01:0.3; % case 24
epsilons = 0.01:0.01:0.1; % case 24
obj_low = zeros(length(epsilons),1);
for i = 1:length(epsilons)
    for iN = 1:length(iN)
        L = get_scenario_problem_order(nMC, Ns(iN), epsilons(i), beta);
        if L >= 1
            obj_sorted = sort(obj(iN,:),'ascend');
            obj_low(i) = max(obj_low(i), obj_sorted(L));
        else
            iN, i
        end
    end
end
save([casename,'-obj-lower-bound.mat'],'obj_low','epsilons');

%% Scenario Approach
% violation probabilities 
f_eps = figure('Position', fig_size);
errorbar(Ns,mean(eps,2),std(eps,[],2),'LineWidth',2), hold on,
plot(Ns,eps_pri,'-v','LineWidth',2), hold on,
% errorbar(Ns,mean(eps_post,2),std(eps_post,[],2),'LineWidth',2), hold on,
plot(Ns,mean(eps_post,2),'-o','LineWidth',2), hold on,
% xlim([0,100]) % case 3
xlabel('sample complexity'),ylabel('violation probability')
legend('out-of-sample','a-priori','a-posteriori')
set(gca,'FontSize',12,'fontname','times')
xlim([0 1050])
hold off
print(f_eps,'-depsc','-painters',[casename,'-scenario-approach-epsilon.eps'])

% objective values
[eps_sort, ind] = sort(mean(eps,2),'ascend');
f_obj = figure('Position', fig_size);
% errorbar(eps_sort, mean(obj(ind,:),2),std(obj(ind,:),[],2),'-','LineWidth',2)
% plot(eps_sort, mean(obj(ind,:),2),'-x','LineWidth',2), hold on,
plot(eps(:),obj(:),'ko'), hold on,
plot(eps_pri, mean(obj,2),'-v','LineWidth',2), hold on,
plot(mean(eps_post,2), mean(obj,2),'-d','LineWidth',2), hold on,
plot(epsilons, obj_low,'-^','LineWidth',2), hold on,
% xlim([0, 0.1]) % case 3
xlabel('violation probability'),ylabel('objective value')
legend('out-of-sample','a-priori','a-posteriori','lower bound',...
    'Location','NorthEast')
set(gca,'FontSize',12,'fontname','times')
xlim([0 0.3])
hold off
print(f_obj,'-depsc','-painters',[casename,'-scenario-approach-objective.eps'])

