
function runsim2

% data parameters
s=100; % obs per person
M=20; % number of responses
K=[5:5:25]; % number of groups in data
nk=length(K); % number of cases
n=100; % number of people
burnin=500; % burn in period

% run simulations
allK=zeros(n,nk);
for i=1:1000;
    for q=1:nk;
        k=findk(n,s,M,K(q),burnin);
        allK(k,q)=allK(k,q)+1;
        disp(['loop ' num2str(i) ', true K = ' num2str(K(q)) ', recovered K = ' num2str(k)]);
        plotsimdata(allK,K);
        drawnow
    end
    if isequal(i/5,round(i/5));
        save montecarlo;
    end
end

   

    
    
%----------------------------------------------------------
function k=findk(n,s,M,K,burnin); 

% modelling parameters
a=10^-10; % prior shape
b=10^-10; % prior scale
B=1; % base distribution with parameter beta

% make up an observed data set
[X,theta,alloc]=makedata2(n,K,s,M); % makedata

% housekeeping
MB=M*B; % summed betas
rrate=20; % refresh rate for plot
itrr=50; % refresh rate for screen display
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
for ss=1:burnin;
        
        % on screen update
        its=its+1; %count the iteration
        if isequal(its/itrr,round(its/itrr));
            disp(['iteration ' num2str(its)]); 
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
    


%----------------------------------------------------------
function [X,T,alloc]=makedata2(n,K,s,M)

% parameters for each group, sampled from symmetric Dirichlet prior
T=rand(K,M); 
T=T./repmat(sum(T,2),1,M);

% allocate each participant to a group.
w=gamrnd(1,1,K,1);
w=w/sum(w);
alloc=[1:K]';
for i=K+1: n;
    tmp=rand; ind=1;
    while tmp>w(ind);
        tmp=tmp-w(ind);
        ind=ind+1;
    end
    alloc=[alloc; ind];
end

% make data
X=zeros(n,M); % data
for i=1:n; for j=1:s; % over all obs & folks
    tmp=rand; ind=1;
    while tmp>T(alloc(i),ind);
        tmp=tmp-T(alloc(i),ind);
        ind=ind+1;
    end
    X(i,ind)=X(i,ind)+1; % add obs
end;end



%----------------------------------------------------------
function plotsimdata(K,kl)

figure(1); clf; hold on;
[n,m]=size(K);
ee=10^-10;
K=(K+ee)./repmat(sum(K+ee,1),n,1);
for i=1:n;
    for j=1:m
        if K(i,j)~=0;
            s=K(i,j)^.5;
            rectangle('position',[kl(j)-s/2,i-s/2,s,s],'edgecolor','w','facecolor','k');
        end
    end
end
        
% edit pic
plot([0 30],[0 30],'k:');
fs=8;
xlabel('True number of groups','fontsize',fs)
ylabel('Recovered number of groups','fontsize',fs)
set(gca,'xlim',[1 30],'ylim',[1 30],'fontsize',fs);
set(gcf,'paperunits','centimeters','paperposition',[1 1 12 12])
