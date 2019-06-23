clear; clc; close all;

fig_size = [10,10,800,400];
beta = 10^(-3);

casename = 'ex_case3sc';
resultpath = './ccDCOPF/';

% casename = 'ex_case24_ieee_rts';
% resultpath = './temp/';

method = 'convex approximation';
type = 'markov bound';
% type = 'ball-box';

nMC = 10;
% Ns = [10:10:100,200:100:500];
N = 100;

eps = [0.01:0.01:0.2,0.3:0.1:0.9];
eps_empirical = zeros(length(eps), nMC);
obj_ball = zeros(length(eps), nMC);
for ieps = 1:length(eps)
    result = load([resultpath,casename,'-',method,'-',type,...
            '-results-N=',num2str(N),'-epsilon=',num2str(eps(ieps)),'.mat']);
    for iMC = 1:nMC
        eps_empirical(ieps, iMC) = result.results(iMC).eps_ofs;
        obj(ieps, iMC) = result.results(iMC).obj;
    end
end


save([casename,'-',method,'-','type','-results-N=',num2str(N),'.mat'],...
    'eps', 'eps_empirical','obj');

