function [eps, violated] = check_violation_prob(constr_in, u, data, ops)
%%CHECK_VIOLATION_PROB

eps = NaN; tol = 1e-4;
% assume the last dim is the data
datdim = ndims( data );

assert( size(u,1) == size(data,1) );
% n_constr = size(constr,1);
N = size(data,datdim);
if ops.verbose
    disp(['Getting Out-of-Sample Violation Prob using ', num2str(N), ' points']);
end
constr = [sdpvar(constr_in) >= 0];
% constr = constr_in;
vio = zeros(1,N);
for idata = 1:N
    if (ops.verbose) && (mod(idata,N/10) == 0 )
        disp(idata);
    end
    dat = aux.extract_dimdata(data, datdim, idata);
    assign(u, dat);
    res = check(constr);
%     res
    assert( all(~isnan(res)));
    vio(idata) = ~all( res > -tol );
end
eps = sum(vio) / N;

if nargout == 2
    violated.indices = find(vio == 1);
    violated.scenarios = aux.extract_dimdata(data, datdim, violated.indices);
end

%% Tried 3 different approaches
% the one above is the fastest (at least 100 times faster)
% 1. (above) assign different values to the same variable, then use check() to get residues
% this does not require creating any new LMI objects
% 2. creating N new constraints with N data points, then use check() to get residues of all constraints
% 3. even more stupid than approach 2

end