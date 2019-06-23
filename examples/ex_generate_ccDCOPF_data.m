clear; clc;

% casename = 'ex_case3sc';
casename = 'ex_case24_ieee_rts';
% casename = 'ex_case30';
% casename = 'case57';
% casename = 'ex_case118';

% distribution = 'gaussian';
distribution = 'beta';

mpc = loadcase(casename);
const = ex_extract_ccDCOPF(mpc);

% datapath = ['../data/ccDCOPF/',casename,'/'];
% datapath = ['../data/ccDCOPF/bound/'];
datapath = ['~/Documents/gdrive/Results-cc-DCOPF/data/',casename,'/',distribution,'/'];


% for N_train = 10:10:100
% for N_train = 1000:1000:4000
for N_train = [10:10:100,2.^(7:11)]
    for i = 1:10
        switch distribution
            case 'gaussian'
                d_err = mvnrnd(zeros(const.nload,1), (0.05*diag(const.d_hat)).^2, N_train)';
            case 'beta'
                d_err = zeros(const.nload, N_train);
                for id = 1:const.nload
                    err = betarnd(25.2414, 25.2692, 1, N_train);
                    d_err(id,:) = (err-0.5)/2 * const.d_hat(id);
%                     hist(d_err(id,:))
                end
            otherwise
                error('no such distribution');
        end   
        save([datapath,casename,'-traindata-N=',num2str(N_train),'-iMC=',num2str(i),'.mat'],'d_err');
    end
end

N_test = 10^4;
% N_test = 10^3;
switch distribution
    case 'gaussian'
        d_err = mvnrnd(zeros(const.nload,1), (0.05*diag(const.d_hat)).^2, N_test)';
    case 'beta'
        d_err = zeros(const.nload, N_test);
        for id = 1:const.nload
            err = betarnd(25.2414, 25.2692, 1, N_test);
            d_err(id,:) = (err-0.5)/2 * const.d_hat(id);
        end
    otherwise
        error('no such distribution');
end 
save([datapath,casename,'-testdata-N=',num2str(N_test),'.mat'],'d_err');

figure
hist(d_err(1,:))