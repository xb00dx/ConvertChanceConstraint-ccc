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
        N_lb = d; N_ub = d;
        beta_ub = 1;
        % find the first N_ub such that beta_ub < beta
        while (beta_ub > beta)
            N_ub = N_ub * 2;
%             N_ub = N_ub^2;
            beta_ub = calculate_beta(epsilon, d, N_ub);
        end
        % then begin binary search
        while (N_ub - N_lb) > 1
            assert(N_ub > N_lb);
            N_mid = floor( (N_ub + N_lb)/2 );
            beta_mid = calculate_beta(epsilon, d, N_mid);
            if beta_mid > beta
                N_lb = N_mid;
            else
                N_ub = N_mid;
            end
        end
        N = N_ub;
    case 'fast' % '2009' in [Campi2009], same as 'fast'
        N = ceil( 2/epsilon * (log(1/beta) + d) );
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
% [Calafiore2006] Giuseppe C Calafiore, Marco C Campi, and others, �The scenario approach to robust control design,� IEEE Transactions on Automatic Control, 2006.
% [Campi2008] Marco C Campi and Simone Garatti, �The exact feasibility of randomized solutions of uncertain convex programs,� SIAM Journal on Optimization, vol. 19, no. 3, pp. 1211�1230, 2008.
% [Campi2009] M. C. Campi, S. Garatti, and M. Prandini, �The scenario approach for systems and control design,� Annual Reviews in Control, vol. 33, no. 2, pp. 149�157, 2009.

%% calculate_beta
% Every iteration needs to calculate the value of beta
% Two versions were implemented and compared
% Parameters: d_in = 24, epsilon = 1e-4, beta = 1e-5
% First version: 3.183780 seconds
% Second version: 4.477356 seconds

%% first verion, using for loops
function beta_out = calculate_beta(eps_in, d_in, N_in)
    log_eps = log(eps_in); log_1_eps = log(1-eps_in);
    aux = zeros(d_in,1);
    aux(d_in) = (N_in-0)*log_1_eps;
    for i = 1:(d_in-1)
        % to be more accurate, taking log on nchoosek, then sum them
        aux(i) = sum(log(1:N_in)) - sum(log(1:i)) - sum(log(1:(N_in-i)))...
            + i*log_eps + (N_in-i)*log_1_eps;
    end
    beta_out = sum( exp(aux) );
end

%% second verion, avoiding for loops by matrix operation
% function beta_out = calculate_beta(eps_in, d_in, N_in)
%     log_eps = log(eps_in); log_1_eps = log(1-eps_in);
%     % aux1 is a column vector: log( N!/0!) ... log( N!/(d-1)!)
%     m1 = 1:1:N_in; assert(size(m1,1) == 1);
%     aux1 = sum( triu( log(ones(d_in,1)*m1) ) ,2);
%     % aux2 is a column vector: log( 0!) ... log( (d-1)!)
%     m2 = N_in:(-1):1; assert(size(m2,1) == 1);
%     aux2 = sum( triu( log(ones(d_in,1)*m2) ), 2);
% %     coeffs = aux1-aux2;
%     % for checking
% %     coeffs = exp( aux1-aux2 );
% %     aa = exp(aux1); bb = exp( aux2 ); open aa, open bb;
%     aux = aux1 - aux2 + (0:1:(d_in-1))'*log_eps + (N_in:(-1):(N_in-d_in+1))'*log_1_eps;
%     assert(size(aux,2) == 1);
%     beta_out = sum( exp(aux) );
% end