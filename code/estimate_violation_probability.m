function [eps, violated] = estimate_violation_probability(constr_in, u, data, ops)
%%ESTIMATE_VIOLATION_PROBABILITY estimate the out-of-sample violation proabability
% using the given data set
%   [EPS, VIOLATED] = ESTIMATE_VIOLATION_PROBABILITY(CONSTR_IN, U, DATA, OPS)
%
%   returning a RESULTS struct and SUCCESS flag.
%
%   Inputs (some are optional):
%       INPUTS : explain inputs
%
%   Outputs (some are optional):
%       OUTPUTS ： 
%
%   Calling syntax options:
%       [OUTPUTS] = FUNCTION(INPUTS)
%
%   Examples:
%       [outputs] = function(inputs)
%   ConvertChanceConstraint (CCC)
%   Copyright (c) 2018-2019
%   by X.Geng
%
%   This file is part of CCC.
%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See https://github.com/xb00dx/ConvertChanceConstraint-ccc for more info.
%   Last Edited: July.26.2019

%% Default settings
if ~isfield(ops,'verbose')
    ops.verbos= 1;
end
if ~isfield(ops,'tol')
    tol = 1e-9; % this might cause numerical problems 
else
    tol = ops.tol;
end 

eps = NaN;

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

end