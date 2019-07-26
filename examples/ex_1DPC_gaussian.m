function ex_1DPC_gaussian()
%EX_1DPC_GAUSSIAN  Examples of 1-dim Probabilistic Point Covering

%   ConvertChanceConstraint (CCC)
%   Copyright (c) 2018-2019
%   by X.Geng
%
%   This file is part of CCC.
%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See https://github.com/xb00dx/ConvertChanceConstraint-ccc for more info.
%   Last Edited: July.26.2019

%% 1-dim Probabilistic Point Covering
% \min_{x,r} r \\
%       s.t. P( x-r <= \xi <= x+r ) >= 1-epsilon
%            r >= 0
% \xi is from a standard Gaussian distribution N(0,1)
% this code plots the feasible region and optimal solution
dist = makedist('Normal','mu',0,'sigma',1);

%% Plot the true feasible region
% use \rho as a parameter
% x-r = \Phi^{-1}(\rho)
% x+r = \Phi^{-1}(1-\epsilon+\rho)
epsilons = 0.05:0.02:0.1; n_epsilon = length(epsilons);
n_rho = 100;
xs = NaN*ones(n_rho,n_epsilon); rs = NaN*ones(n_rho,n_epsilon);
for i_epsilon = 1:n_epsilon
    epsilon = epsilons(i_epsilon);
    rhos = epsilon*(1:n_rho)/n_rho; 
for i_rho = 1:n_rho
    rho = rhos(i_rho);
    xs(i_rho,i_epsilon) = 0.5* ( icdf(dist,rho) + icdf(dist,1-epsilon+rho) );
    rs(i_rho,i_epsilon) = 0.5* (-icdf(dist,rho) + icdf(dist,1-epsilon+rho) );
end
end

feas_region = figure;
legend_str = {};
for i_epsilon = 1:n_epsilon
    legend_str = [legend_str, ['\epsilon=',num2str(epsilons(i_epsilon))]];
    plot(xs(:,i_epsilon), rs(:,i_epsilon),'LineWidth',1.5), hold on,
end
xlabel('center: x'), ylabel('radius: r'),
legend(legend_str,'Location','best'),
title('probabilistic point covering')
hold off
% print(feas_region,'-depsc','-painters','1d_pointcovering_feasibleregion.eps')
% print(feas_region,'-dsvg','1d_pointcovering_feasibleregion.svg')
% save('1d_pointcovering_feasibleregion.mat','xs','rs','epsilons','rhos');
end