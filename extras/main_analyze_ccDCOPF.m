clear; clc; close all;

casename = 'case3sc';
resultpath = './ccDCOPF/';
% method = 'convex approximation';
method = 'scenario approach';

Ns = [10:10:100]; nMC = 10;
eps = zeros(length(Ns), nMC);

for iN = 1:length(Ns)
    result = load([resultpath,casename,'-',method,'-results-N=',num2str(Ns(iN)),'.mat']);
    for iMC = 1:nMC
        eps(iN, iMC) = result.results(iMC).eps_ofs;
    end
end

plot(Ns, mean(eps'))
plot(Ns, eps')