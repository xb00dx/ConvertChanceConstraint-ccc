function L = get_scenario_problem_order(M, N, epsilon, delta)
%% GET_SCENARIO_PROBLEM_ORDER
% Given (M,N, epsilon, delta), find the largest L such that
% delta \ge \sum_{i=0}^{L-1}
%      nchoosek(M,i)*(1-epsilon)^{N*i}*[1-(1-epsilon)^N]^{M-i}
% this is used to construct lower bounds

assert( (M >=1) && (N>=1) && (epsilon>0) && (delta>0) && (epsilon<1) && (delta<1));

log_1_epsilon = log(1-epsilon);
log_1_1_epsilon_N = log( 1- exp(N*log_1_epsilon) );
rhs_sum = exp(M*log_1_1_epsilon_N);
% assert( rhs_sum <= delta );
if rhs_sum > delta
    L = 1;
    return;
end
for i = 1:(M-1)
    if rhs_sum > delta
        L = i;
        return;
    else
        log_value = sum(log((M-i+1):1:M))-sum(log(1:i))+N*i*log_1_epsilon+(M-i)*log_1_1_epsilon_N;
        rhs_sum = rhs_sum + exp(log_value);
    end
end
error('need a bigger M!');

end