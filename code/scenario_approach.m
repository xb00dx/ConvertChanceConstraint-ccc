function F_sa = scenario_approach(F0, w, data, ops)
%%SCENARIO_APPROACH handle a chance constraint using the scenario approach
%   F_SA = SCENARIO_APPROACH(F0, W, DATA, OPS)
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

% constraint: F(x,w) <= 0
% replaced t: F(x, w^i) <= 0
scdim = ndims(data);
N = size(data, scdim);
% assert( length(w) == size(data,1) );
% assert( size(w) == size(data, scdim ) );
% disp('missing an assertion here');

F = sdpvar(F0); % vectorize to speed up

F_sa = [];
for i = 1:N
    if (ops.verbose) && (mod(i, round(N/100)) == 0)
        disp(['scenario ', num2str(i)]);
    end
    data_i = extract_data(data,scdim,i);
    F_sa = [F_sa sdpvar(replace(F, w, data_i)) >= 0];
end

end
