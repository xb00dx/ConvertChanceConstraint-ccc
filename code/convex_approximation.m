function F_ca = convex_approximation(F0, w, data, ops)
%% CONVEX_APPROXIMATION 
% convert the chance constraint prob(F(x,w) <= 0) >= 1 - epsilon
% to a solvable form using convex approximation 
% where F(x,w): R^n \times R^d --> R^m
% currently only using Markov bound phi(z) = [1+z]_+
% equivalent form looks like
% f(x,w^i) + t * ones(m,1) <= u_i* ones(m,1), i=1....N
% sum(u) <= N*epsilon*t

% by default, the last dimension is where the data stored
scdim = ndims(data);
N = size(data, scdim); % size of the dataset

% vectorizing F, this could speed up the process
% otherwise F could be structures with different sizes
F = sdpvar(F0);
m = length(F);

epsilon = ops.epsilon;

if isfield(ops,'type')
    type = ops.type;
else
    type = 'markov bound';
end
    
switch lower(type)
    case 'markov bound'
%         sdpvar t;
%         u = sdpvar(N,1,'full');
% %         F_ca = [sum(u) <= N*t*epsilon; u>= zeros(N,1); t >= 0.001];
%         for i = 1:N
%             if (ops.verbose) && (mod(i, round(N/100)) == 0)
%                 disp(['scenario ', num2str(i)]);
%             end
%             data_i = extract_data(data,scdim,i);
%             F_ca_i = sdpvar(replace(F, w, data_i));
% %             F_ca = [F_ca;...
% %                 -F_ca_i+t*ones(m,1) <= u(i)*ones(m,1)];
%         end
        sdpvar t;
        u = sdpvar(N,1,'full');
%         v = sdpvar(N,1,'full');
        % constraint t > 0 is not necessary here 
        F_ca = [sum(u) + N*t*epsilon <= 0; u>= zeros(N,1)];
        for i = 1:N
            if (ops.verbose) && (mod(i, round(N/100)) == 0)
                disp(['scenario ', num2str(i)]);
            end
            data_i = extract_data(data,scdim,i);
            F_ca_i = sdpvar(replace(F, w, data_i));
%             F_ca = [F_ca;...
%                 -F_ca_i <= v(i)*ones(m,1);
%                 v(i) - t <= u(i)];
            F_ca = [F_ca;...
                -F_ca_i - t*ones(m,1) <= u(i)*ones(m,1)];
        end        
    otherwise
        error('unknown/unimplemented bound type for convex approximation');
end

end

