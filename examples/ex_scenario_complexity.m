clear; clc;
epsilon = 0.1; beta = 10^(-5);
d_all = 2.^(2:8);

N_exact = zeros(length(d_all),1);
N_fast = zeros(length(d_all),1);
N_2006 = zeros(length(d_all),1);

for id = 1:length(d_all)
    disp(id);
    [N_exact(id),~] = get_scenario_num(d_all(id), epsilon, beta, 'exact');
    [N_fast(id),~] = get_scenario_num(d_all(id), epsilon, beta, 'fast');
    [N_2006(id),~] = get_scenario_num(d_all(id), epsilon, beta, '2006');
end

figure;
plot(d_all,N_exact,'-o'),hold on
plot(d_all,N_fast,'-x'),hold on
plot(d_all,N_2006,'-^'),hold on
xlabel('number of decision variables (d)')
ylabel('sample complexity (N)')
legend('[Campi2008]','[Campi2009]','[Calafiore2006]')
% set(gca,'xscale','log')