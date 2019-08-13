function [X,theta,alloc]=makedata(n,K,s,M)


%distparms=[.5 1.5];
distparms=[1 1];
theta=rand(K,M); % associated parameters
for i=1:K; theta(i,:)=theta(i,:)/sum(theta(i,:)); end % convert to rates
alloc=[[1:K]'; round(betarnd(distparms(1),distparms(2),n-K,1)*(K-1))+1]; % allocations for each group
X=zeros(n,M); % data
for i=1:n; for j=1:s; % over all obs & folks
    tmp=rand; ind=1;
    while tmp>theta(alloc(i),ind);
        tmp=tmp-theta(alloc(i),ind);
        ind=ind+1;
    end
    X(i,ind)=X(i,ind)+1; % add obs
end;end
