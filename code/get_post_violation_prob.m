function out = get_post_violation_prob(N,k,beta)

tol = 1e-10;

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
out = 1-t1;
end