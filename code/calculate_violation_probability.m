function epsilon = calculate_violation_probability(N,k,beta,opt)
%%CALCULATE_VIOLATION_PROBABILITY calculate the violation proabability guaranteed
% by the scenario approach theory
%   EPSILON = CALCULATE_VIOLATION_PROBABILITY(N,K,BETA,OPT)
%
%   returning .
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
% 
%% Calculations are based on the sample complexity bound in the following references
% 
%   [Campi2008] (same as 'exact'): find the smallest integer $N_{2008}$ such that
%   $\sum_{i=0}^{d-1} C_N^i  \epsilon^i * (1-\epsilon)^{N-i} \ge \beta$,
%   where $C_N^i$ means N choose i
%
%   [Campi2009] (same as 'fast'): 
%   $N_{2009} = \frac{2}{\epsilon}(\log(\frac{1}{\beta}) + d)$
%   therefore: epsilon = 2/N*(n-log(beta));
%  
%	[Campi2016]: (same as 'posterior'): 
%	epsilon(k) = 1 - (\frac{\beta}{N C_N^k})^(1/(N-k)),
%	where $C_N^k$ means N choose k
% 	
% 	[Campi2019]: (same as 'non-convex'):
%
% 	
%% References
%   [Calafiore2006] Giuseppe C Calafiore, Marco C Campi, and others, 
%       "The scenario approach to robust control design," IEEE Transactions on
%       Automatic Control, 2006.
%   [Campi2008] Marco C Campi and Simone Garatti, "The exact feasibility of 
%       randomized solutions of uncertain convex programs," SIAM Journal on
%       Optimization, vol. 19, no. 3, pp. 1211-1230, 2008.
%   [Campi2009] M. C. Campi, S. Garatti, and M. Prandini, "The scenario approach
%       for systems and control design," Annual Reviews in Control, vol. 33,
%       no. 2, pp. 149-157, 2009.
%	[Campi2016] Campi, MC, and S Garatti. “Wait-and-Judge Scenario Optimization.”
%		Mathematical Programming, 2016, 1–35.
% 	[Campi2019] Campi, Marco C, Simone Garatti, and Federico Alessandro Ramponi. 
%		“A General Scenario Theory for Non-Convex Optimization and Decision Making.”
%		IEEE Transactions on Automatic Control, 2019.
% 	
%   ConvertChanceConstraint (CCC)
%   Copyright (c) 2018-2019
%   by X.Geng
%
%   This file is part of CCC.
%   Covered by the 3-clause BSD License (see LICENSE file for details).
%   See https://github.com/xb00dx/ConvertChanceConstraint-ccc for more info.
%   Last Edited: August.03.2019

assert( k<= N );
tol = 1e-9;

% if nargout <= 3
% opt = 'exact';
% end

switch opt
	case 'exact'
		ref = 'Campi2008';
	case 'fast'
		ref = 'Campi2009';
	case 'posterior'
		ref = 'Campi2016';
	case 'non-convex'
		ref = 'Campi2019';
	otherwise
		ref = opt;
end

switch ref
    case 'Campi2008'
        l = tol; v_l = 1;
        r = 1; v_r = 0;
        while (v_l - v_r) > tol
            p = (l+r)/2;
            v_p = cal_exact_epsilon(N, n, p);
            if v_p > beta
                l = p;
                v_l = cal_exact_epsilon(N, n, l);
            else
                r = p;
                v_r = cal_exact_epsilon(N, n, r);
            end 
        end
        epsilon = p;
    case 'Campi2009'
        epsilon = 2/N*(n-log(beta));
    case 'Campi2018'
    	% this part of code can be found in the appendix of [Campi2018]
		m = k:1:N;
		aux1 = sum(triu(log(ones(N-k+1,1)*m),1),2);
		aux2 = sum(triu(log(ones(N-k+1,1)*(m-k)),1),2);
		coeffs = aux2-aux1;
		t1 = 0; t2 = 1;
		while t2-t1 > tol
		    t = (t1+t2)/2;
		    val = 1 - beta/(N+1)*sum( exp(coeffs-(N-m')*log(t)) );
		    if val >= 0
		        t2 = t;
		    else
		        t1 = t;
		    end
		end
		epsilon = 1-t1;
    case 'Campi2019'
    	log_1_epsilon = ( log(beta) - log(N) - sum(log((k+1):N)) + sum(log(1:(N-k))) ) / (N-k);
    	epsilon = 1- exp(log_1_epsilon);
	otherwise
    	error('Option ', opt, ' not available!');		
end

end % end function

function beta1 = cal_exact_epsilon(N1, n1, eps1)
	beta1 = 0;
	for i1 = 0:(n1-1)
	    aux = sum(log((N1-i1+1):N1)) - sum(log(1:i1)) + i1*log(eps1) + (N1-i1)*log(1-eps1);
	    beta1 = beta1 + exp(aux);
	end
end % end function