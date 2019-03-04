clear; clc;

casename = 'ex_case3sc';
% casename = 'ex_case24_ieee_rts';
% casename = 'ex_case30';
% casename = 'case57';
% casename = 'ex_case118';

mpc = loadcase(casename);
const = ex_extract_ccDCOPF(mpc);

% datapath = ['../data/ccDCOPF/',casename,'/'];
% datapath = ['../data/ccDCOPF/bound/'];
datapath = ['~/Documents/gdrive/CCC-Working/Data/',casename,'/'];

for N_train = 10:10:100
% for N_train = 1000:1000:4000
% for N_train = 2.^(11:13)
    for i = 1:100
        d_err = mvnrnd(zeros(const.nload,1), (0.05*diag(const.d_hat)).^2, N_train)';
        save([datapath,casename,'-traindata-N=',num2str(N_train),'-iMC=',num2str(i),'.mat'],'d_err');
    end
end

% N_test = 10^4;
N_test = 10^3;
d_err = mvnrnd(zeros(const.nload,1), (0.05*diag(const.d_hat)).^2, N_test)';
save([datapath,casename,'-testdata-N=',num2str(N_test),'.mat'],'d_err');

figure
hist(d_err(1,:))