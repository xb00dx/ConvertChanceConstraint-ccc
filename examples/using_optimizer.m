% 
% if using_optimizer
%     % Convert Chance Constraint
%     d_err_data = sdpvar(const.nload,N_train,'full');
%     constr_prob = prob(constr_inner,d_err, ops.epsilon,d_err_data,ops);
%     % Introducing auxilary variable to use optimizer
%     sdpvar aux_obj;
%     constr_obj = [objective <= aux_obj];
%     dec_vars = {aux_obj,g,s,eta};
%     ind.obj = 1; ind.g = 2; ind.s = 3; ind.eta = 4;
%     ccDCOPF = optimizer([constr_det; constr_prob; constr_obj],...
%         aux_obj,opt_yalmip, d_err_data, dec_vars);
%     save([resultpath,casename,'-',ops.method,'-N=',num2str(N_train),'-workspace.mat']);
%     for iMC = 1:nMC
%         disp(['Monte-Carlo Simulation ', num2str(iMC)]);
%         traindata = load([datapath,casename,...
%             '-traindata-N=',num2str(N_train),'-iMC=',num2str(iMC),'.mat'] );
%         tic;
%         [sol,errorcode,yalmipinfo,~,problem_para0] = ccDCOPF{traindata.d_err};
%         t_solve = toc;
%         disp(yalmipinfo);
%         assert(errorcode == 0); % for successfully solved
%         % assign values to the sdpvar variables to check violation prob
%         assign(aux_obj, sol{ind.obj}); assign(g, sol{ind.g});
%         assign(s, sol{ind.s}); assign(eta, sol{ind.eta});
%         eps_ofs = check_violation_prob(constr_inner, d_err,testdata.d_err, ops);
%         disp(['out of sample violation probability is: ', num2str(eps_ofs)]);
%         % save results
%         results(iMC).epsilon = ops.epsilon;
%         results(iMC).N_train = N_train;
%         results(iMC).N_test = N_test;
%         results(iMC).eps_ofs = eps_ofs;
%         results(iMC).obj = sol{ind.obj};
%         results(iMC).g = sol{ind.g};
%         results(iMC).s = sol{ind.s};
%         results(iMC).eta = sol{ind.eta};
%         results(iMC).solvetime = t_solve;
%         results(iMC).ops = ops;
% %         eps_test(iMC,iN) = eps_ofs;
%         switch ops.method
%             case 'scenario approach'
%             disp('finding suppport scenarios');
%             [support_scenarios, sc_indices] = get_support_scenarios(problem_para0,...
%                 traindata.d_err, ind.obj, sol, ops);
%             results(iMC).support_scenarios = support_scenarios;
%             results(iMC).sc_indices = sc_indices;
%             disp(sc_indices);
%             case 'sample average approximation'
%                 [~,violated] = check_violation_prob(constr_inner, d_err,traindata.d_err, ops);
%                 results(iMC).violated = violated;
%                 disp([num2str(length(violated.indices)),' scenarios being violated']);
%             otherwise
%                 error('no such method');
%         end
%     end
%     if strcmp(ops.method, 'sample average approximation')
%         save([resultpath,casename,'-',ops.method,'-',ops.type,...
%             '-results-N=',num2str(N_train),'-epsilon=',num2str(ops.epsilon),'.mat'],'results');
%     else
%         save([resultpath,casename,'-',ops.method,'-results-N=',num2str(N_train),'.mat'],'results');
%     end
%     clear results;
% else