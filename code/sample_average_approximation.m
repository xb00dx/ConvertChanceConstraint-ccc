function [F_saa, F_saa_data] = sample_average_approximation(F0, w, data, ops)
% F_saa: the complete set of constraints: F_saa = [F_saa_prob; F_saa_data];
% F_saa_data: creating this part is time-consuming, so we re-use it

% constraint: F(x,w) <= 0
% replaced t: F(x, w^i) <= 0
scdim = ndims(data);
N = size(data, scdim);
F = sdpvar(F0);
m = length(F);

if isfield(ops,'M')
    M = ops.M;
else
    if ops.verbose
        disp('Big-M value not specified, setting to the default value');
    end
    M = 10^4;
end

if isfield(ops,'alpha')
    alpha = ops.alpha;
else
    if ops.verbose
        disp('Alpha value not specified, setting to the value of epsilon');
    end
    assert( isfield(ops,'epsilon') );
    alpha = ops.epsilon;
end

if isfield(ops,'pi')
    assert(length(ops.pi) == N);
    pi = ops.pi;
else
    pi = ones(N,1)/N;
end

z = binvar(N,1,'full');
F_saa_prob = [pi' * z <= alpha];

if isfield(ops, 'reuse') && ops.reuse && isfield(ops,'constraints')
%     assert(isfield(ops,'constraints'));
    F_saa_data = ops.constraints;
else
    F_saa_data = [];
    for i = 1:N
        if (ops.verbose) && (mod(i, round(N/100)) == 0)
            disp(['scenario ', num2str(i)]);
        end
        data_i = extract_data(data,scdim,i);
        F_saa_data_i = sdpvar( replace(F, w, data_i) );
        F_saa_data = [F_saa_data; F_saa_data_i + M*z(i)*ones(m,1) >= 0];
    end
end

F_saa = [F_saa_prob; F_saa_data];
end
