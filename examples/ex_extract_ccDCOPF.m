function const = ex_extract_ccDCOPF(mpc)
define_constants;

const.ngen = size(mpc.gen,1);
const.genbuses = mpc.gen(:,GEN_BUS);
const.nbus = size(mpc.bus,1);
const.loadbuses = find(mpc.bus(:,PD) > 0);
const.nload = length(const.loadbuses);
const.nline = size(mpc.branch,1);

npoly = mpc.gencost(1,4) - 1; % that column means (n+1) coefficients
const.c_g = mpc.gencost(:, end - 1);
const.c_s = 10^3;
const.Q = zeros(const.ngen, const.ngen);
if npoly == 2
    const.Q = diag( mpc.gencost(:, end - 2) );
end

selected_line = find(mpc.branch(:,RATE_A) > 1e-3);

const.H = makePTDF(mpc);
const.Hg = const.H(selected_line, const.genbuses);
const.Hd = const.H(selected_line,const.loadbuses);
% Hw = H(:, wind.bus);
const.d_hat = mpc.bus(const.loadbuses, PD);
const.f_u = mpc.branch(selected_line,RATE_A); const.f_l = -mpc.branch(selected_line,RATE_A);
const.g_u = mpc.gen(:, PMAX); const.g_l = mpc.gen(:,PMIN);

end
