clear; clc; close all;

fig_size = [10,10,800,600];
beta = 10^(-2);

% casename = 'ex_case3sc'; N = 100;
casename = 'ex_case24_ieee_rts'; N = 2048;

result_sa = load([casename,'-scenario approach-results.mat']);
% result_ca = load([casename,'-convex approximation-type-results-N=',num2str(N),'.mat']);
% result_saa = load([casename,'-sample average approximation-sampling and discarding-results-N=',num2str(N),'.mat']);
result_rc = load([casename,'-robust counterpart-results-N=',num2str(N),'.mat']);
% result_lb = load([casename,'-obj-lower-bound.mat']);

f_eps = figure('Position', fig_size);
plot(0.01:0.01:0.9,0.01:0.01:0.9,'g-.','LineWidth',2), hold on,
plot(mean(result_sa.eps_pri,2), mean(result_sa.eps_empirical,2),'-x','LineWidth',2), hold on,
plot(mean(result_sa.eps_post,2), mean(result_sa.eps_empirical,2),'-*','LineWidth',2), hold on,
% plot(result_saa.epsilons, mean(result_saa.eps_empirical,2),'-o','LineWidth',2), hold on,
plot(result_rc.eps, mean(result_rc.eps_empirical_box,2)*ones(size(result_rc.eps)),'--v','LineWidth',2), hold on,
% plot(result_rc.eps, mean(result_rc.eps_empirical_ball,2),':v','LineWidth',2), hold on,
plot(result_rc.eps, mean(result_rc.eps_empirical_ballbox,2),'-v','LineWidth',2), hold on,
% plot(result_rc.eps, mean(result_rc.eps_empirical_budget,2),'-.v','LineWidth',2), hold on,
% plot(result_ca.eps, mean(result_ca.eps_empirical,2),'-d','LineWidth',2), hold on,
legend('ideal case','SA:priori','SA:posteriori','SAA:s&d','RC:box','RC:ball','RC:ballbox','RC:budget','CA:markov','Location','NorthWest')
set(gca,'yscale','log')
xlim([0,0.9]), ylim([1e-4 10])
xlabel('violation probability (setting)'),ylabel('violation probability (out-of-sample)')
set(gca,'FontSize',12,'fontname','times')
% print(f_eps,'-depsc','-painters',[casename,'-all-methods-epsilon.eps'])
 
f_eps_err = figure('Position', fig_size);
plot(0.01:0.01:0.9,0.01:0.01:0.9,'g-.','LineWidth',2), hold on,
errorbar(mean(result_sa.eps_pri,2), mean(result_sa.eps_empirical,2),std(result_sa.eps_empirical,[],2),'-x','LineWidth',2), hold on,
errorbar(mean(result_sa.eps_post,2), mean(result_sa.eps_empirical,2),std(result_sa.eps_empirical,[],2),'-*','LineWidth',2), hold on,
% errorbar(result_saa.epsilons, mean(result_saa.eps_empirical,2),std(result_saa.eps_empirical,[],2),'-o','LineWidth',2), hold on,
plot(result_rc.eps, mean(result_rc.eps_empirical_box,2)*ones(size(result_rc.eps)),'--v','LineWidth',2), hold on,
% errorbar(result_rc.eps, mean(result_rc.eps_empirical_ball,2),std(result_rc.eps_empirical_ball,[],2),':v','LineWidth',2), hold on,
errorbar(result_rc.eps, mean(result_rc.eps_empirical_ballbox,2),std(result_rc.eps_empirical_ballbox,[],2),'-v','LineWidth',2), hold on,
% errorbar(result_rc.eps, mean(result_rc.eps_empirical_budget,2),std(result_rc.eps_empirical_budget,[],2),'-.v','LineWidth',2), hold on,
% errorbar(result_ca.eps, mean(result_ca.eps_empirical,2), std(result_ca.eps_empirical,[],2),'-d','LineWidth',2), hold on,
legend('ideal case','SA:priori','SA:posteriori','SAA:s&d','RC:box','RC:ball','RC:ballbox','RC:budget','CA:markov','Location','NorthWest')
xlim([0,0.9])
xlabel('violation probability (setting)'),ylabel('violation probability (out-of-sample)')
set(gca,'FontSize',12,'fontname','times')
% print(f_eps_err,'-depsc','-painters',[casename,'-all-methods-epsilon-errorbar.eps'])

f_obj = figure('Position', fig_size);
% plot(result_lb.epsilons, result_lb.obj_low, ':^'), hold on,
plot(mean(result_sa.eps_pri,2), mean(result_sa.obj,2),'-x','LineWidth',2), hold on,
plot(mean(result_sa.eps_post,2), mean(result_sa.obj,2),'-*','LineWidth',2), hold on,
% plot(result_saa.epsilons, mean(result_saa.obj,2),'-o','LineWidth',2), hold on,
plot(result_rc.eps, mean(result_rc.obj_box,2)*ones(size(result_rc.eps)),'--v','LineWidth',2), hold on,
% plot(result_rc.eps, mean(result_rc.obj_ball,2),':v','LineWidth',2), hold on,
plot(result_rc.eps, mean(result_rc.obj_ballbox,2),'-v','LineWidth',2), hold on,
% plot(result_rc.eps, mean(result_rc.obj_budget,2),'-.v','LineWidth',2), hold on,
% plot(result_ca.eps, mean(result_ca.obj, 2),'-d','LineWidth',2), hold on,
legend('SA:priori','SA:posteriori','SAA:s&d','RC:box','RC:ball','RC:ballbox','RC:budget','CA:markov')
xlabel('violation probability \epsilon (setting)'),ylabel('objective value')
xlim([0 0.9])
set(gca,'FontSize',12,'fontname','times')
% print(f_obj,'-depsc','-painters',[casename,'-all-methods-objective.eps'])
 

% f_obj_emp = figure('Position', fig_size);
% % plot(result_lb.epsilons, result_lb.obj_low,'-^'), hold on,
% [result_sa_eps_empirical,indices] = sort( mean(result_sa.eps_empirical,2),'ascend' );
% plot(result_sa_eps_empirical, mean(result_sa.obj(indices,:),2),'-v'), hold on,
% [result_saa_eps_empirical,indices] = sort( mean(result_saa.eps_empirical,2),'ascend' );
% plot(result_saa_eps_empirical, mean(result_saa.obj(indices,:),2),'-d'), hold on,
% [result_rc_eps_empirical_box,indices] = sort( mean(result_rc.eps_empirical_box,2),'ascend' );
% plot(result_rc_eps_empirical_box, mean(result_rc.obj_box(indices,:),2),'-*'), hold on,
% [result_rc_eps_empirical_ball,indices] = sort( mean(result_rc.eps_empirical_ball,2),'ascend' );
% plot(result_rc_eps_empirical_ball, mean(result_rc.obj_ball(indices,:),2),'-*'), hold on,
% [result_rc_eps_empirical_ballbox,indices] = sort( mean(result_rc.eps_empirical_ballbox,2),'ascend' );
% plot(result_rc_eps_empirical_ballbox, mean(result_rc.obj_ballbox(indices,:),2),'-x'), hold on,
% [result_rc_eps_empirical_budget,indices] = sort( mean(result_rc.eps_empirical_budget,2),'ascend' );
% plot(result_rc_eps_empirical_budget, mean(result_rc.obj_budget(indices,:),2),'-x'), hold on,
% [result_ca_eps_empirical,indices] = sort( mean(result_ca.eps_empirical,2),'ascend' );
% plot(result_ca_eps_empirical, mean(result_ca.obj,2),'-d','LineWidth',2), hold on,
% % legend('lower bound','SA','SAA:s&d','RC:box','RC:ball','RC:ballbox','RC:budget')
% legend('SA','SAA:s&d','RC:box','RC:ball','RC:ballbox','RC:budget','CA:markov')
% set(gca,'xscale','log')
% xlim([0 0.06])