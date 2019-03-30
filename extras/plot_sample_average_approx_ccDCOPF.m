clear; clc; close all;

fig_size = [10,10,800,400];
beta = 10^(-3);

casename = 'ex_case3sc';
resultpath = './ccDCOPF/';

% casename = 'ex_case24_ieee_rts';
% resultpath = './temp/';

method = 'sample average approximation';
% type = 'box';
type = 'sampling and discarding';

nMC = 10;
% Ns = [10:10:100,200:100:500];
N = 100;

epsilons = [0.01:0.01:0.1,0.2:0.1:0.9];
eps_empirical = zeros(length(epsilons), nMC);
obj = zeros(length(epsilons), nMC);
for ieps = 1:length(epsilons)
    result_file = [resultpath,casename,'-',method,'-',type,...
            '-results-N=',num2str(N),'-epsilon=',num2str(epsilons(ieps)),'.mat'];
    if exist(result_file, 'file')
        result = load(result_file);
        for iMC = 1:nMC
            eps_empirical(ieps, iMC) = result.results(iMC).eps_ofs;
            obj(ieps, iMC) = result.results(iMC).obj;
        end
    else
        eps_empirical(ieps, :) = NaN;
        obj(ieps, :) = NaN;
    end
end

save([casename,'-',method,'-',type,'-results-N=',num2str(N),'.mat'], 'epsilons', 'eps_empirical', 'obj');


% calculate lower bounds
% lb = load('ex_case3sc-obj-lower-bound');

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
% 
% % violation probabilities 
% % clr = colormap('lines');
% f_eps = figure('Position', fig_size);
% % dat = squeeze( eps_empirical_box(:,Ns==N,:) );
% % yyaxis left
% errorbar(epsilons, mean(eps_empirical,2), std(eps_empirical,[],2),'LineWidth',2), hold on,
% % errorbar(eps,mean(eps_empirical_ballbox,2),std(eps_empirical_ballbox,[],2),'Color',clr(5,:),'LineWidth',2), hold on,
% % plot(eps,eps_pri,'-v','LineWidth',2), hold on,
% % errorbar(Ns,mean(eps_post,2),std(eps_post,[],2),'LineWidth',2), hold on,
% % plot(Ns,mean(eps_post,2),'-o','LineWidth',2), hold on,
% % xlim([0,100])
% xlabel('\epsilon (setting)'),ylabel('$$\hat{\epsilon}$$ (out-of-sample)','Interpreter','Latex')
% % legend('RC:box','RC:ball-box','Location','NorthWest')
% set(gca,'FontSize',12,'fontname','times')
% % yyaxis right
% % errorbar(eps,mean(eps_empirical_ball,2),std(eps_empirical_ball,[],2),'LineWidth',2), hold on,
% % ylim([-1e-6 5e-4])
% % legend('RC:ball','Location','NorthEast')
% % set(gca,'FontSize',12,'fontname','times')
% hold off
% % print(f_eps,'-depsc','-painters',[casename,'-',method,'-',type,'-epsilon.eps'])
% 
% % objective values
% [eps_sort, ind] = sort(mean(eps,2),'ascend');
% f_obj = figure('Position', fig_size);
% errorbar(eps, mean(obj_box,2),std(obj_box,[],2),'-v','LineWidth',2), hold on,
% % errorbar(eps, mean(obj_ball,2),std(obj_ball,[],2)), hold on,
% errorbar(eps, mean(obj_ballbox,2),std(obj_ballbox,[],2),'-d','LineWidth',2), hold on,
% plot(lb.epsilons, lb.obj_low,'-^','LineWidth',2), hold on,
% xlim([0, 0.1])
% xlabel('violation probability (setting)'),ylabel('objective value')
% legend('RC:box','RC:ball-box','lower bound',...
%     'Location','SouthWest')
% set(gca,'FontSize',12,'fontname','times')
% hold off
% % print(f_obj,'-depsc','-painters',[casename,'-scenario-approach-objective.eps'])

