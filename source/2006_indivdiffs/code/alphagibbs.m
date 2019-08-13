% draw the posterior distribution over alpha, assuming that data arise from
% a mixture of dirichlet processes, with a Gamma(a,b) prior over alpha. the
% data augmentation formulation from Escobar & West (1995) is used.

% i think matlab does gamma the other way round from E&W, since i'm getting
% alpha increasing as k/n decreases....

% observed data
n=50; % number of observations
k=5; % number of observed groups

% prior on alpha
a=1; % prior shape
b=1; % prior scale

% housekeeping
burnin=500; % burn in period
thinning=5; % lag between samples
nsamp=1000000; % number of samples 
A=sparse(nsamp,1); % empty matrix of alphas
rrate=200; % refresh rate for plot
nbins=100; % resolution of the plot

% initialise sampler
alpha=gamrnd(a,b); % sample alpha from it's prior
eta=betarnd(alpha+1,n); % sample eta from the conditional posterior

% run sampler
cnt=0; %counter variable
for s=1:nsamp + burnin/thinning;
    for i=1:thinning;
		w=(a+k-1)/(a+k-1+n*(b-log(eta))); % weight of the first gamma
		if rand<=w; % if alpha comes from the first gamma
            alpha = gamrnd(a+k,1/(b-log(eta))); % sample it.
		else % if alpha comes from the second gamma
            alpha = gamrnd(a+k-1,1/(b-log(eta))); % sample it
		end
		eta=betarnd(alpha+1,n); % sample eta
    end
    if s>burnin/thinning; % if we're burnt in
        cnt=cnt+1; % update count
        A(cnt)=alpha; % record alpha
        if isequal(cnt/rrate,round(cnt/rrate)); % online display 
            figure(1); clf; hold on;
            [h,x]=hist(A(1:cnt),nbins); h=h/cnt/(x(2)-x(1));
            plot(x,h,'k-','linewidth',2);
            xlabel('\alpha');
            ylabel('p(\alpha | k,n)')
            str=['iteration ' num2str(cnt) ', k=' num2str(k) ', n=' num2str(n) ', w=' num2str(w,2) ', eta=' num2str(eta,2)];
            disp(str); drawnow;
        end 
    end
end

% plot the results
figure(1); clf; hold on;
[h,x]=hist(A,nbins); h=h/nsamp/(x(2)-x(1));
plot(x,h,'k-');
xlabel('\alpha');
ylabel('p(\alpha | k,n)')

% save it
fname=['data_k' num2str(k) '_n' num2str(n)];
eval(['save ' fname]);
