function [n_rmv] = get_scenario_num_removed(N, d, epsilon, beta)
%% 
% Given N, d, \epsilon and \beta, calculate k
% the number of scenarios could be removed
% used in scenario approach or sample average approximation

log_eps = log(epsilon);
log_1_eps = log(1-epsilon);

for k = 0:N
    aux_var = zeros(k+d,1);
    aux_var(k+d) = (N-0)*log_1_eps;
    for i = 1:(k+d-1)
        % this line takes the log on all the nchoosek,
        % then calculate the sum
        aux_var(i) = sum(log(1:N)) - sum(log(1:i)) - sum(log(1:(N-i)))...
            + i*log_eps + (N-i)*log_1_eps;
    end
    log_sum_lhs = log( sum( exp( aux_var ) ) );
    log_rhs = log(beta) + sum(log(1:k)) + sum(log(1:(d-1))) - sum(log(1:(k+d-1)));
    if log_sum_lhs > log_rhs
       n_rmv = k-1;
%        status = 1;
       return;
    end    
end

% n_rmv = -1;
% status = -1;

end