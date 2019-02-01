function [N,k] = get_scenario_num(d, epsilon, beta, optin)
%GET_SCENARIO_NUM  calculate sample complexity in scenario theory

%% Sample Complexity (references at the end of this function)
%
% *Sample Complexity Bound by Type* (most commonly used ones)
% 
% * 'exact' in [Campi2008]
% 
% find the smallest integer $N_{2008}$ such that
% $\sum_{i=0}^{d-1} C_N^i  \epsilon^i * (1-\epsilon)^{N-i} \ge \beta$,
% where $C_N^i$ means N choose i
%
% * 'fast' in [Campi2009]
% 
% $N_{2009} = \frac{2}{\epsilon}(\log(\frac{1}{\beta}) + d)$
% 
% * 's-and-d'
%
%
%
% *Sample Complexity Bound by year*
%
% * '2006' in [Calafiore2006]
%
% $N_{2006} = \frac{2}{\epsilon}\log(\frac{1}{\beta}) + 2d + \frac{2d}{\epsilon}\log(\frac{2}{\epsilon})$   
%
% * '2008' in [Campi2008], same as opt='exact'
% * '2009' in [Campi2009], same as 'fast'

%% Initialization
N = 0; k = 0;
switch optin
    case '2008'
        opt = 'exact';
    otherwise
        opt = optin;
end

switch opt
    case 'exact' % '2008' in [Campi2008], same as opt='exact'
        % #scenario cannot be smaller than (d-1)
        n = d-1;
        log_eps = log(epsilon); log_1_eps = log(1-epsilon);
        while 1
            aux = zeros(d,1);
            aux(d) = (n-0)*log_1_eps;
            for i = 1:(d -1)
                % to be more accurate, taking log on nchoosek, then sum them
                aux(i) = sum(log(1:n)) - sum(log(1:i)) - sum(log(1:(n-i)))...
                    + i*log_eps + (n-i)*log_1_eps;
            end
            sum_res = sum( exp( aux ) );
            if sum_res < beta
               break; 
            else
                % increamental enumeration, could be very slow
                % better using sth like binary search
                n = n+1; 
            end
        end
        N = n;
    case 'fast' % '2009' in [Campi2009], same as 'fast'
        N = 2/epsilon * (log(1/beta) + d);
    case 's-and-d'
    case 'prior'
    case 'posterior' 
    case '2006' % in [Calafiore2006]    
        n = 2/epsilon*log(1/beta) + 2*d + 2*d/epsilon*log(2/epsilon);
        N = ceil(n);
    case '2010'
    otherwise
        error('no such option');
end
end

%% References
% [Calafiore2006] Giuseppe C Calafiore, Marco C Campi, and others, “The scenario approach to robust control design,” IEEE Transactions on Automatic Control, 2006.
% [Campi2008] Marco C Campi and Simone Garatti, “The exact feasibility of randomized solutions of uncertain convex programs,” SIAM Journal on Optimization, vol. 19, no. 3, pp. 1211–1230, 2008.
% [Campi2009] M. C. Campi, S. Garatti, and M. Prandini, “The scenario approach for systems and control design,” Annual Reviews in Control, vol. 33, no. 2, pp. 149–157, 2009.
