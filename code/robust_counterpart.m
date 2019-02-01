function F_rc = robust_counterpart(F0, w, data, ops)

% constraint: F(x,w) <= 0
% replaced t: F(x, w^i) <= 0
scdim = ndims(data);
N = size(data, scdim);
% assert( length(w) == size(data,1) );
% assert( size(w) == size(data, scdim ) );
% disp('missing an assertion here');

F = sdpvar(F0); % vectorize to speed up
m = length(F);

assert( scdim==2 );
d = size(data,1);

% if strcmpi(ops.reformulate, 'manual')
%     assert(isfield(ops.model));
%     assert(length(ops.parameter) == m);
%     w_ind = getvariables(w);
%     var_ind = depends(F);
%     assert( isempty(ismember(w_ind, var_ind) == 0)  );
%     x = recover( setdiff(var_ind, w_ind));
% %     assert(length(x) == )
% end

if isfield(ops,'support')
    support = ops.support;
else
    if ops.verbose
        disp('estimate the support by assuming elements of w are independent Gaussian');
    end
    if scdim == 2
        mu_data = mean(data,2);
        std_data = std(data,[],2);
        support.lb = norminv(ops.beta/2*ones(d,1), mu_data, std_data);
        support.ub = norminv(1-ops.beta/2*ones(d,1), mu_data, std_data);     
        support.center = (support.lb+support.ub)/2;
        support.radius = (support.ub-support.lb)/2;
%         assert( min(support.radius) > 0);
    else
        error('currently unable to handle matrix type uncertainties');
    end
end

switch lower(ops.type)
    case 'box'
        F_rc = [F>=0;
%             norm( (w-support.center)./support.radius, inf) <= 1;
%         -ones(d,1) <= (w-support.center)./support.radius <= ones(d,1);
            support.lb <= w <= support.ub;
            uncertain(w)];
    case 'ball'
        F_rc = [F>=0;
            norm( (w-support.center)./support.radius, 2) <= sqrt(2*log(1/ops.epsilon));
%            (w-support.center)'*(w-support.center)./(support.radius).^2 <= 2*log(1/ops.epsilon);
            uncertain(w)];
    case 'ball-box'
        F_rc = [F>=0;
%             norm( (w-support.center)./support.radius, inf) <= 1;
%             -ones(d,1) <= (w-support.center)./support.radius <= ones(d,1);
            support.lb <= w <= support.ub;
            norm( (w-support.center)./support.radius, 2) <= sqrt(2*log(1/ops.epsilon));
            uncertain(w)];
    case 'budget'
        u = sdpvar(d,1,'full');
        F_rc = [F>=0;
%             norm( (w-support.center)./support.radius, 1) <= sqrt(2*d*log(1/ops.epsilon));
            -u <= (w-support.center)./support.radius <= u;
            sum(u) <= sqrt(2*d*log(1/ops.epsilon));
            uncertain(w); uncertain(u)];
    otherwise
        error('unknown uncertainty set type')
end

          
end
