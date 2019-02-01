function out = get_pre_violation_prob(N,n,beta, opt)

tol = 1e-7;
    
switch opt
    case 'exact'
%         error('not implemented');
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
        out = p;
    case '2009'
        out = 2/N*(n-log(beta));
end

end

function beta1 = cal_exact_epsilon(N1, n1, eps1)
beta1 = 0;
for i1 = 0:(n1-1)
    aux = sum(log((N1-i1+1):N1)) - sum(log(1:i1)) + i1*log(eps1) + (N1-i1)*log(1-eps1);
    beta1 = beta1 + exp(aux);
end

end