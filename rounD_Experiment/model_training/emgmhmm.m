function [Flamda, logp] = emgmhmm(O, inilamda, maxiter, tol)
%   基于EM算法的GMHMM参数训练

inistate = inilamda.guessINISTATE;
tr = inilamda.guessTR;
mu = inilamda.guessMU;
sigma = inilamda.guessSIGMA;

% 状态数
% N = length(inistate);

prelogp = -inf;
dif = inf;
i = 0;
% logplist = 0;

while (i<maxiter) && (abs(dif)>=tol)
    i = i+1;
    B = observation_prob(O, mu,sigma);
    [salpha, sbeta, logp] = fbward(inistate,tr,B);
    if logp>prelogp
        Flamda.guessINISTATE = inistate;
        Flamda.guessTR = tr;
        Flamda.guessMU = mu;
        Flamda.guessSIGMA = sigma;
    end
    %     if i == 1
    %         inilogp = logp;
    %     end
    [mergexi,Oinipoint,Oendpoint] = compute_xi(tr,B,salpha,sbeta);
    trainlamda = paraupdate(mergexi,Oinipoint,Oendpoint,O);

    inistate = trainlamda.guessINISTATE;
    tr = trainlamda.guessTR;
    mu = trainlamda.guessMU;
    sigma = trainlamda.guessSIGMA;

    if i~=1
        dif = (logp-prelogp)/(abs(prelogp)+(prelogp==0));
        if isinf(dif)
            disp('dif is inf!')
            keyboard
        end
    end
    % 绘制图形
    %     logplist = [logplist, logp];
    %     plot(logplist(2:end))
    %     pause(0.001)
    %     if (rem(i,10)==0) || (i==1)
    %         fprintf('Numstates:%4d,  Iteration:%4d,  LogPdifference:%12g\n',...
    %             N, i, dif)
    %     end

    prelogp = logp;
end

B = observation_prob(O, mu,sigma);
[~, ~, logp] = fbward(inistate,tr,B);
if logp>prelogp
    Flamda.guessINISTATE = inistate;
    Flamda.guessTR = tr;
    Flamda.guessMU = mu;
    Flamda.guessSIGMA = sigma;
end

% totalincreased = logp-inilogp;
% fprintf('\nFinished: %4d states    LogP increased:%12g\n',...
%     N, totalincreased)

end