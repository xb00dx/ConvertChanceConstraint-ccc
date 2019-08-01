clear; clc; close all;

fig_size = [10,10,800,400];
beta = 10^(-2);

% casename = 'ex_case3sc'; N = 100;
casename = 'ex_case24_ieee_rts'; N = 2048;

eps_scale = 0.01:0.01:0.1;

result_sa = load([casename,'-scenario approach-results.mat']);
result_ca = load([casename,'-convex approximation-type-results-N=',num2str(N),'.mat']);
result_saa = load([casename,'-sample average approximation-sampling and discarding-results-N=',num2str(N),'.mat']);
result_rc = load([casename,'-robust counterpart-results-N=',num2str(N),'.mat']);
% result_lb = load([casename,'-obj-lower-bound.mat']);

f_eps = figure('Position', fig_size);
lgd_str = {};
plot(eps_scale,eps_scale,'g-.','LineWidth',2), hold on, lgd_str = [lgd_str,'ideal case'];
plot(nanmean(result_sa.eps_pri,2), nanmean(result_sa.eps_empirical,2),'-x','LineWidth',2), hold on, lgd_str = [lgd_str,'SA:priori'];
plot(nanmean(result_sa.eps_post,2), nanmean(result_sa.eps_empirical,2),'-*','LineWidth',2), hold on, lgd_str = [lgd_str,'SA:posteriori'];
plot(result_saa.epsilons, nanmean(result_saa.eps_empirical,2),'-o','LineWidth',2), hold on, lgd_str = [lgd_str,'SAA:s&d'];
plot(result_rc.eps, nanmean(result_rc.eps_empirical_box,2)*ones(size(result_rc.eps)),'--v','LineWidth',2), hold on, lgd_str = [lgd_str,'RC:box'];
% plot(result_rc.eps, nanmean(result_rc.eps_empirical_ball,2),':v','LineWidth',2), hold on, lgd_str = [lgd_str,'RC:ball'];
% plot(result_rc.eps, nanmean(result_rc.eps_empirical_ballbox,2),'-v','LineWidth',2), hold on, lgd_str = [lgd_str,'RC:ballbox'];
% plot(result_rc.eps, nanmean(result_rc.eps_empirical_budget,2),'-.v','LineWidth',2), hold on, lgd_str = [lgd_str,'RC:budget'];
plot(result_ca.eps, nanmean(result_ca.eps_empirical,2),'-d','LineWidth',2), hold on, lgd_str = [lgd_str,'CA:markov'];
legend(lgd_str,'Location','NorthWest')
set(gca,'yscale','log')
% xlim([0,0.9]), ylim([1e-4 10])
xlim([0,0.12]), ylim([1e-3 0.2])
xlabel('violation probability (setting)'),ylabel('violation probability (out-of-sample)')
set(gca,'FontSize',12,'fontname','times')
print(f_eps,'-depsc','-painters',[casename,'-all-methods-epsilon.eps'])
 
f_eps_err = figure('Position', fig_size);
lgd_str = {};
% plot(eps_scale,eps_scale,'g-.','LineWidth',2), hold on, lgd_str = [lgd_str,'ideal case'];
errorbar(nanmean(result_sa.eps_pri,2), nanmean(result_sa.eps_empirical,2),nanstd(result_sa.eps_empirical,[],2),'-x','LineWidth',2), hold on, lgd_str = [lgd_str,'SA:priori'];
errorbar(nanmean(result_sa.eps_post,2), nanmean(result_sa.eps_empirical,2),nanstd(result_sa.eps_empirical,[],2),'-*','LineWidth',2), hold on, lgd_str = [lgd_str,'SA:posteriori'];
errorbar(result_saa.epsilons, nanmean(result_saa.eps_empirical,2),nanstd(result_saa.eps_empirical,[],2),'-o','LineWidth',2), hold on, lgd_str = [lgd_str,'SAA:s&d'];
plot(result_rc.eps, nanmean(result_rc.eps_empirical_box,2)*ones(size(result_rc.eps)),'--v','LineWidth',2), hold on, lgd_str = [lgd_str,'RC:box'];
errorbar(result_rc.eps, nanmean(result_rc.eps_empirical_ball,2),nanstd(result_rc.eps_empirical_ball,[],2),':v','LineWidth',2), hold on, lgd_str = [lgd_str,'RC:ball'];
errorbar(result_rc.eps, nanmean(result_rc.eps_empirical_ballbox,2),nanstd(result_rc.eps_empirical_ballbox,[],2),'-v','LineWidth',2), hold on, lgd_str = [lgd_str,'RC:ballbox'];
% errorbar(result_rc.eps, nanmean(result_rc.eps_empirical_budget,2),nanstd(result_rc.eps_empirical_budget,[],2),'-.v','LineWidth',2), hold on,
errorbar(result_ca.eps, nanmean(result_ca.eps_empirical,2), nanstd(result_ca.eps_empirical,[],2),'-d','LineWidth',2), hold on, lgd_str = [lgd_str,'CA:markov'];
legend(lgd_str,'Location','NorthWest')
% xlim([0,0.12])
xlim([0,0.09])
% ylim([0,0.09])
xlabel('violation probability (setting)'),ylabel('violation probability (out-of-sample)')
set(gca,'FontSize',12,'fontname','times')
print(f_eps_err,'-depsc','-painters',[casename,'-all-methods-epsilon-errorbar.eps'])

f_obj = figure('Position', fig_size);
lgd_str = {};
% plot(result_lb.epsilons, result_lb.obj_low, ':^'), hold on,
% plot(nanmean(result_sa.eps_pri,2), nanmean(result_sa.obj,2),'-x','LineWidth',2), hold on, lgd_str = [lgd_str,'SA:priori'];
% plot(nanmean(result_sa.eps_post,2), nanmean(result_sa.obj,2),'-*','LineWidth',2), hold on, lgd_str = [lgd_str,'SA:posteriori'];
% plot(result_saa.epsilons, nanmean(result_saa.obj,2),'-o','LineWidth',2), hold on, lgd_str = [lgd_str,'SAA:s&d'];
plot(result_rc.eps, nanmean(result_rc.obj_box,2)*ones(size(result_rc.eps)),'--v','LineWidth',2), hold on, lgd_str = [lgd_str,'RC:box'];
plot(result_rc.eps, nanmean(result_rc.obj_ball,2),':v','LineWidth',2), hold on, lgd_str = [lgd_str,'RC:ball'];
plot(result_rc.eps, nanmean(result_rc.obj_ballbox,2),'-v','LineWidth',2), hold on, lgd_str = [lgd_str,'RC:ballbox'];
% plot(result_rc.eps, nanmean(result_rc.obj_budget,2),'-.v','LineWidth',2), hold on,
% plot(result_ca.eps, nanmean(result_ca.obj, 2),'-d','LineWidth',2), hold on, lgd_str = [lgd_str,'CA:markov'];
legend(lgd_str)
xlabel('violation probability \epsilon (setting)'),ylabel('objective value')
xlim([0 0.1])
set(gca,'FontSize',12,'fontname','times')
print(f_obj,'-depsc','-painters',[casename,'-all-methods-objective.eps'])
 

% f_obj_emp = figure('Position', fig_size);
% % plot(result_lb.epsilons, result_lb.obj_low,'-^'), hold on,
% [result_sa_eps_empirical,indices] = sort( nanmean(result_sa.eps_empirical,2),'ascend' );
% plot(result_sa_eps_empirical, nanmean(result_sa.obj(indices,:),2),'-v'), hold on,
% [result_saa_eps_empirical,indices] = sort( nanmean(result_saa.eps_empirical,2),'ascend' );
% plot(result_saa_eps_empirical, nanmean(result_saa.obj(indices,:),2),'-d'), hold on,
% [result_rc_eps_empirical_box,indices] = sort( nanmean(result_rc.eps_empirical_box,2),'ascend' );
% plot(result_rc_eps_empirical_box, nanmean(result_rc.obj_box(indices,:),2),'-*'), hold on,
% [result_rc_eps_empirical_ball,indices] = sort( nanmean(result_rc.eps_empirical_ball,2),'ascend' );
% plot(result_rc_eps_empirical_ball, nanmean(result_rc.obj_ball(indices,:),2),'-*'), hold on,
% [result_rc_eps_empirical_ballbox,indices] = sort( nanmean(result_rc.eps_empirical_ballbox,2),'ascend' );
% plot(result_rc_eps_empirical_ballbox, nanmean(result_rc.obj_ballbox(indices,:),2),'-x'), hold on,
% [result_rc_eps_empirical_budget,indices] = sort( nanmean(result_rc.eps_empirical_budget,2),'ascend' );
% plot(result_rc_eps_empirical_budget, nanmean(result_rc.obj_budget(indices,:),2),'-x'), hold on,
% [result_ca_eps_empirical,indices] = sort( nanmean(result_ca.eps_empirical,2),'ascend' );
% plot(result_ca_eps_empirical, nanmean(result_ca.obj,2),'-d','LineWidth',2), hold on,
% % legend('lower bound','SA','SAA:s&d','RC:box','RC:ball','RC:ballbox','RC:budget')
% legend('SA','SAA:s&d','RC:box','RC:ball','RC:ballbox','RC:budget','CA:markov')
% set(gca,'xscale','log')
% xlim([0 0.06])