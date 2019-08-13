function runsim

% data parameters
n=10000; % number of people
s=50; % obs per person
M=20; % number of responses
K=500; % number of groups in data

% simulation parameters
fname='dpsimdata3'; % filename
burnin=100; % burn in period
thinning=5; % lag between samples
nsamp=10000; % number of samples 

% modelling parameters
a=1/2; % prior shape
b=1/2; % prior scale
B=1; % base distribution with parameter beta

% make up an observed data set
[X,theta,alloc]=makedata(n,K,s,M); % makedata
eval(['save ' fname]);

% housekeeping
AA=sparse(nsamp,1); % empty matrix of alphas
KK=sparse(nsamp,1); % empty matrix of alphas
MB=M*B; % summed betas
rrate=20; % refresh rate for plot
itrr=1; % refresh rate for screen display
nbins=50; % resolution of the alpha plot
fs=7; % fontsize
format compact; % display style

% initialise assignments
G=ones(n,1); % initially assign everyone to group 1
N=n; % number of people assigned to each group
k=1; % total number of groups
Qm=sum(X,1); % number of m-responses in each group
Q=sum(Qm); % number of responses in each group
Xn=sum(X,2); % total obs for each person

% initalise hyperparameters
alpha=1; %gamrnd(a,1/b); % sample alpha from it's prior (note: matlab uses the 1/b parameterisation) 
eta=.5; %betarnd(alpha,n); % sample eta from the conditional posterior

% construct tables of useful logs
logB=gammaln(B+[0:sum(Xn)]); % logs for terms in gammas(B+z)
logMB=gammaln(MB+[0:sum(Xn)]); % logs for terms in gamma(MB+z)

% run sampler
cnt=0; %counter variable
its=0; %total iterations
burntin=0; % burnt in yet?
for ss=1:nsamp + burnin/thinning;
    
    % include lag
    for i=1:thinning; 
        
        % on screen update
        its=its+1; %count the iteration
        if isequal(its/itrr,round(its/itrr));
            disp(['iteration ' num2str(its) ', sample ' num2str(cnt)]); 
            drawnow
        end
        
        for p=1:n % over all people
            
            % delete the old assignment
            g=G(p); % retrieve the old assignment
            G(p)=0; % delete the assignment
            N(g)=N(g)-1; % decrease the count of people in the group
            Qm(g,:)=Qm(g,:)-X(p,:); % decrease count of m-responses;
            Q(g)=Q(g)-Xn(p); % decrease count of all responses;
            
            % if a group disappears, update all matrices
            if N(g)==0
                G=G-(G>g); % update the assignment vector
                tmp=setdiff([1:k],g); % indices of remaining groups
                N=N(tmp); % delete from group size vector
                Qm=Qm(tmp,:); % delete from m-response count matrix
                Q=Q(tmp); % delete from response count vector
                k=k-1; % decrease k
            end
            
            % calculate assigment log-probs for existing groups
            P=zeros(1,k+1); % initialise assignment probs vector 
            for g=1:k % over all existing groups
               for m=1:M; % over all response options 
                   P(g)=P(g) + logB(Qm(g,m)+X(p,m)+1) - logB(Qm(g,m)+1); % numerator term
               end
               P(g)=P(g) - logMB(Q(g)+Xn(p)+1) + logMB(Q(g)+1); % denominator
               P(g)=P(g) + log(N(g)); % prior
            end
            
            % calculate log-prob for new group
            for m=1:M; % over all response options 
               P(k+1)=P(k+1) + logB(X(p,m)+1) - logB(1); % numerator term
            end
            P(k+1)=P(k+1) - logMB(Xn(p)+1) + logMB(1); % denominator
            P(k+1)=P(k+1) + log(alpha); % prior
            
            % normalise the distribution
            P=P-min(P); % remove the constants
            P=exp(P); % convert log-probs to probs
            P=P/sum(P); % normalize
            
            % assignments
            g=1; % group to assign to
            u=rand; % uniform random variate        
            while u>P(g) % if it's not this group
                u=u-P(g); % take off the prob mass
                g=g+1; % move on to the next group
            end
            
            % if it's a new group
            if g==k+1;
                k=k+1; % update the number of groups
                Qm=[Qm; zeros(1,M)]; % enlarge m-response count 
                Q=[Q; 0]; % enlarge response count
                N=[N; 0]; % enlarge group count
            end
            G(p)=g; % make assignment
            Qm(g,:)=Qm(g,:)+X(p,:); % update m-reponse count;
            Q(g)=Q(g)+Xn(p); % update total response count
            N(g)=N(g)+1; % update group count

        end
        
        % resample the hyperparameters
        alpha = gamrnd(a+k-1,1/(b-log(eta))); % sample alpha.
		eta=betarnd(alpha,n); % sample eta
        
    end
    
    % record and display
    if ~burntin; 
        if ss>burnin/thinning; burntin=1; end
    else % if we're burnt in
        
        
        cnt=cnt+1; % update count
        AA(cnt)=alpha; % record alpha
        KK(cnt)=k; % record k
        if isequal(cnt/rrate,round(cnt/rrate)); % online display 
            figure(1); clf; 
            set(gcf,'paperunits','centimeters','paperposition',[1 1 12 6])
            
            % plot alpha
            subplot(1,2,1); hold on;
            [h1,x1]=hist(AA(1:cnt),nbins); h1=h1/cnt/(x1(2)-x1(1));
            plot(x1,h1,'k-','linewidth',2);
            xlabel('\alpha','fontsize',fs); 
            ylabel('p(\alpha | x)','fontsize',fs)
            set(gca,'box','on','fontsize',fs);
            
            % plot k            
            subplot(1,2,2); hold on;
            jl=full(min(KK(1:cnt))); jh=full(max(KK(1:cnt)));
            for x2=jl:jh
                h2=sum(KK(1:cnt)==x2)/cnt;
                plot([x2 x2],[0 h2],'k-','linewidth',2);
            end
            xlabel('k','fontsize',fs); 
            ylabel('p(k | x)','fontsize',fs)
            set(gca,'xlim',[jl-1 jh+1]);
            set(gca,'box','on','fontsize',fs);            
            drawnow;
        end 
        eval(['save ' fname]);
        
    end
    
end
