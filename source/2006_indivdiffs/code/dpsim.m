% dp simulations
function dpsim

% observed data
%makedata('dpsim1')
load dpsim4

% prior on alpha
a=1/2; % prior shape
b=1/2; % prior scale
bta=1; % base distribution

% housekeeping
burnin=1; % burn in period
thinning=1; % lag between samples
nsamp=10000; % number of samples 
AA=sparse(nsamp,1); % empty matrix of alphas
KK=sparse(nsamp,1); % empty matrix of alphas
rrate=1; % refresh rate for plot
nbins=10; % resolution of the plot

% initialise sampler
G=ones(n,1); % everyone in group 1
k=1; % total number of groups
Qjm=sum(X,1); % sum in groups
Qj=sum(Qjm); % other sum groups
alpha=gamrnd(a,1/b); % sample alpha from it's prior (note: matlab uses the 1/b parameterisation) 
eta=betarnd(alpha,n); % sample eta from the conditional posterior

% run sampler
cnt=0; %counter variable
for ss=1:nsamp + burnin/thinning;
    ss
    for i=1:thinning;
        for p=1:n % over all people
            % gibbs sample that person's assignment
            P=zeros(1,k+1); % probs for Gibbs
            oldg=find(G(p,:)); % assignment
            G(p,1:k)=zeros(1,k); % delete assignment
            Qjm(oldg,:)=Qjm(oldg,:)-X(p,:); % delete corresponding count;
            Qj(oldg)=Qj(oldg)-sum(X(p,:)); % delete count
            if sum(G(:,oldg))==0 % if this empties something
                tmp=setdiff([1:k],oldg);
                G=G(:,tmp);
                Qjm=Qjm(tmp,:);
                Qj=Qj(tmp);
                k=k-1;
                P=zeros(1,k+1);
            end
            for g=1:k
                P(g)=gammaln(M*bta + Qj(g)) - sum(gammaln(bta+Qjm(g,:))); % 1st term
                P(g)=P(g) + sum(gammaln(bta+Qjm(g,:)+X(p,:))) - gammaln(M*bta + Qj(g) + sum(X(p,:))); %2nd term
                P(g)=P(g) + log(sum(G(:,g))); % 3rd term    
            end
            P(k+1)=gammaln(M*bta) - M*gammaln(bta); % 1st term
            P(k+1)=P(k+1) + sum(gammaln(bta+X(p,:))) - gammaln(M*bta +sum(X(p,:))); %2nd term
            P(k+1)=P(k+1) + log(alpha); % 3rd term    
            % normalising
            P=P-min(P);
            P=exp(P);
            P=P/sum(P);
            % assignments
            tmp=rand;
            ind=1;
            while tmp>P(ind)
                tmp=tmp-P(ind);
                ind=ind+1;
            end
            if ind==k+1;
                k=k+1;
                Qjm=[Qjm; zeros(1,M)];
                Qj=[Qj; 0];
            end
            G(p,ind)=1; % add assignment
            Qjm(ind,:)=Qjm(ind,:)+X(p,:); % add corresponding count;
            Qj(ind)=Qj(ind)+sum(X(p,:)); % add count

        end
        alpha = gamrnd(a+k-1,1/(b-log(eta))); % sample alpha.
		eta=betarnd(alpha,n); % sample eta
    end
    if ss>burnin/thinning; % if we're burnt in
        cnt=cnt+1; % update count
        AA(cnt)=alpha; % record alpha
        KK(cnt)=k; % record k
        if isequal(cnt/rrate,round(cnt/rrate)); % online display 
            figure(1); clf; 
            % plot alpha
            subplot(1,2,1); hold on;
            [h,x]=hist(AA(1:cnt),nbins); h=h/cnt/(x(2)-x(1));
            plot(x,h,'k-','linewidth',2);
            xlabel('\alpha'); ylabel('p(\alpha | x)')
            % plot k            
            subplot(1,2,2); hold on;
            [h,x]=hist(KK(1:cnt),nbins); h=h/cnt/(x(2)-x(1));
            plot(x,h,'k-','linewidth',2);
            xlabel('k'); ylabel('p(k | x)')
            %str=['iteration ' num2str(cnt) ', k=' num2str(k) ', n=' num2str(n) ', w=' num2str(w,2) ', eta=' num2str(eta,2)];
            %disp(str); 
            drawnow;
        end 
    end
end