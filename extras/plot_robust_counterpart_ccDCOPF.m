clear; clc; close all;

fig_size = [10,10,800,400];
beta = 10^(-3);

% casename = 'ex_case3sc';
% resultpath = './ccDCOPF/';

casename = 'ex_case24_ieee_rts';
% resultpath = './ccDCOPF/';
resultpath = '~/Documents/gdrive/Results-cc-DCOPF/results/ex_case24_ieee_rts/beta/';

method = 'robust counterpart';
% type = 'box';
% type = 'ball-box';

nMC = 10;
% Ns = [10:10:100,200:100:500];
% N = 100;
N = 2048;

% eps = 0;
eps = 0.01;
eps_empirical_box = zeros(length(eps), nMC);
obj_box = zeros(length(eps), nMC);
for ieps = 1:length(eps)
    result = load([resultpath,casename,'-',method,'-','box',...
            '-results-N=',num2str(N),'-epsilon=',num2str(eps),'.mat']);
    for iMC = 1:nMC
        eps_empirical_box(ieps, iMC) = result.results(iMC).eps_ofs;
        obj_box(ieps,  iMC) = result.results(iMC).obj;
    end
end

% eps = 0.1:0.1:0.9;
eps = 0.01:0.01:0.1;
% eps = 0.06:0.01:0.1;
eps_empirical_ball = zeros(length(eps), nMC);
obj_ball = zeros(length(eps), nMC);
for ieps = 1:length(eps)
    result = load([resultpath,casename,'-',method,'-','ball',...
            '-results-N=',num2str(N),'-epsilon=',num2str(eps(ieps)),'.mat']);
    for iMC = 1:nMC
        eps_empirical_ball(ieps, iMC) = result.results(iMC).eps_ofs;
        obj_ball(ieps, iMC) = result.results(iMC).obj;
    end
end

eps_empirical_ballbox = zeros(length(eps), nMC);
obj_ballbox = zeros(length(eps), nMC);
for ieps = 1:length(eps)
    result = load([resultpath,casename,'-',method,'-','ball-box',...
            '-results-N=',num2str(N),'-epsilon=',num2str(eps(ieps)),'.mat']);
    for iMC = 1:nMC
        eps_empirical_ballbox(ieps, iMC) = result.results(iMC).eps_ofs;
        obj_ballbox(ieps, iMC) = result.results(iMC).obj;
    end
end

% eps_empirical_budget = zeros(length(eps), nMC);
% obj_budget = zeros(length(eps), nMC);
% for ieps = 1:length(eps)
%     result = load([resultpath,casename,'-',method,'-','budget',...
%             '-results-N=',num2str(N),'-epsilon=',num2str(eps(ieps)),'.mat']);
%     for iMC = 1:nMC
%         eps_empirical_budget(ieps, iMC) = result.results(iMC).eps_ofs;
%         obj_budget(ieps, iMC) = result.results(iMC).obj;
%     end
% end

save([casename,'-',method,'-results-N=',num2str(N),'.mat'],...
    'eps', 'eps_empirical_box','obj_box','eps_empirical_ballbox','obj_ballbox',...
    'eps_empirical_ball','obj_ball');
% save([casename,'-',method,'-results-N=',num2str(N),'.mat'],...
%     'eps', 'eps_empirical_box','obj_box','eps_empirical_ballbox','obj_ballbox',...
%     'eps_empirical_ball','obj_ball', 'eps_empirical_budget','obj_budget');

return
% calculate lower bounds
lb = load('ex_case3sc-obj-lower-bound');

%% Robust Counterpart
% f_N = figure('Position', fig_size);
% % eps_sel = [1;10];
% eps_lgd = {};
% for i = [1,3,7,10]
%     dat = squeeze( eps_empirical(i,:,:) );
% %     errorbar(Ns,mean(dat,2), std(dat,[],2),'LineWidth',2), hold on
%     plot(Ns, std(dat,[],2),'-x','LineWidth',2), hold on,
% %     plot(Ns, std(dat,[],2)/eps(i),'-x'), hold on,
%     eps_lgd = [eps_lgd ['\epsilon = ',num2str(eps(i))]];
% end
% xlabel('sample size'), ylabel('std of out-of-sample \epsilon')
% legend(eps_lgd, 'Location','NorthEast')
% set(gca,'FontSize',12,'fontname','times')
% hold off
% print(f_N,'-depsc','-painters',[casename,'-',method,'-',type,'-N.eps'])

% violation probabilities 
clr = colormap('lines');
f_eps = figure('Position', fig_size);
% dat = squeeze( eps_empirical_box(:,Ns==N,:) );
% yyaxis left
plot(eps, mean(eps_empirical_box,2)*ones(size(eps)),'Color',clr(1,:),'LineWidth',2), hold on
% errorbar(eps, mean(eps_empirical_box,2), std(eps_empirical_box,[],2),'Color',clr(1,:),'LineWidth',2), hold on,
errorbar(eps,mean(eps_empirical_ball,2),std(eps_empirical_ball,[],2),'Color',clr(3,:),'LineWidth',2), hold on,
errorbar(eps,mean(eps_empirical_ballbox,2),std(eps_empirical_ballbox,[],2),'Color',clr(5,:),'LineWidth',2), hold on,
errorbar(eps,mean(eps_empirical_budget,2),std(eps_empirical_budget,[],2),'Color',clr(6,:),'LineWidth',2), hold on,
% plot(eps,eps_pri,'-v','LineWidth',2), hold on,
% errorbar(Ns,mean(eps_post,2),std(eps_post,[],2),'LineWidth',2), hold on,
% plot(Ns,mean(eps_post,2),'-o','LineWidth',2), hold on,
% xlim([0,100])
xlabel('violation probability \epsilon (setting)'),ylabel('violation probability $$\hat{\epsilon}$$ (out-of-sample)','Interpreter','Latex')
legend('RC:box','RC:ball','RC:ball-box','RC:ball-budget','Location','NorthWest')
set(gca,'FontSize',12,'fontname','times')
% set(gca,'yscale','log')
hold off
print(f_eps,'-depsc','-painters',[casename,'-',method,'-epsilon.eps'])

% objective values
[eps_sort, ind] = sort(mean(eps,2),'ascend');
f_obj = figure('Position', fig_size);
plot(eps, mean(obj_box,2)*ones(size(eps)),'--v','LineWidth',2), hold on,
errorbar(eps, mean(obj_ball,2),std(obj_ball,[],2),':v','LineWidth',2), hold on,
errorbar(eps, mean(obj_ballbox,2),std(obj_ballbox,[],2),'-v','LineWidth',2), hold on,
errorbar(eps, mean(obj_budget,2),std(obj_budget,[],2),'-.v','LineWidth',2), hold on,
% plot(lb.epsilons, lb.obj_low,'-^','LineWidth',2), hold on,
% xlim([0, 0.1])
xlabel('violation probability (setting)'),ylabel('objective value')
legend('RC:box','RC:ball','RC:ball-box','RC:ball-budget','Location','NorthEast')
set(gca,'FontSize',12,'fontname','times')
hold off
print(f_obj,'-depsc','-painters',[casename,'-',method,'-objective.eps'])
