function epsilon = get_violation_prob(N,k,beta,opt)
    switch opt
        case 'posterior'
            ln_1_eps = ( log(beta) - log(N) - sum(log( N:(N-k+1) )) ) / (N-k);
        case 'prior'
            ln_1_eps = ( log(beta) - log(k) - sum(log( N:(N-k+1) )) ) / (N-k);
        otherwise
            error('no such option in get_posterior_prob');
    end
    epsilon = 1 - exp( ln_1_eps );
end