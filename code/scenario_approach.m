function F_sa = scenario_approach(F0, w, data, ops)

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
    F_sa = [F_sa replace(F, w, data_i)];
end

end
