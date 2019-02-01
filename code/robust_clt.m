function constr_ru = robust_clt(epsilon, w, mu, sigma)

nw = length(w);

if length(mu) == 1
    mu = repmat(mu, nw,1);
else
    assert(nw == length(mu));
end
if length(sigma) == 1
    sigma = repmat(sigma, nw,1);
else
    assert( length(sigma) == nw );
end
assert(all(sigma >= 0));

Gamma = icdf(makedist('normal'), 1-epsilon/2);

constr_ru = [uncertain(w);
    -Gamma*sqrt(nw) <= sum( (w-mu)./ sigma ) <= Gamma*sqrt(nw);
    -Gamma*sigma <= w-mu <= Gamma*sigma ];

end