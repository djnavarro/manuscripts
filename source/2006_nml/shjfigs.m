
% draws figure 2 for the paper: a plot of the complexity of all possible
% clustering models with H=20, D=40, N=100 & M=16. the plot shows the
% regret per cluster for all models. bic-type approximations would predict
% this to be constant. it's not.

clear
load regretdata_fig2

% generates all distinguishable clustering models
m=D; rc=[]; inds=[]; nc=[];
for n=1:m; % over all cardinalities
    isdone=0;
    if n==1; ind=m; isdone=1;
    else; ind=[m-n+1 ones(1,n-1)]; end %initial solution
    inds=[inds; ind zeros(1,m-n)]; % add the current solution to inds
    nc=[nc; n]; % cardinality of the current solution
    while ~isdone
        i=n;
        finished=0;
        while ~finished;
            if ind(i-1)-1>ind(i); % if we can move one allocation down, do so
                ind(i-1)=ind(i-1)-1; 
                ind(i)=ind(i)+1;
                finished=0;
                inds=[inds; ind zeros(1,m-n)]; % add the current solution to inds
                nc=[nc; n]; % cardinality of the current solution
            else
                i=i-1; %move back
                if i==1; finished=1; isdone=1; end
            end
        end
    end
end        
   
% finds the complexities
ns=length(nc); rc=zeros(ns,1);
for i=1:ns;
    for j=1:nc(i);
        rc(i)=rc(i)+R(inds(i,j));
    end
end

% bic complexity for some number of clusters
bicc=[1:m]*M*log(N)/2;

% draw figure
figure(2);clf;hold on;
fs=8;
set(gca,'fontsize',fs);
%plot(nc,rc,'k.');
%plot(nc,rc-bicc(nc)','k.');
plot(nc,rc./nc,'k.');
ylabel('Complexity per Cluster','fontsize',fs)
xlabel('Number of Clusters','fontsize',fs)
set(gcf,'paperunits','centimeters','paperposition',[2 2 12 10]);


% draw figure
figure(3);clf;hold on;
fs=8;
set(gca,'fontsize',fs);
plot([0:m],[0 R],'k.-');
ylabel('Complexity of Cluster','fontsize',fs)
xlabel('Size of Cluster','fontsize',fs)
set(gcf,'paperunits','centimeters','paperposition',[2 2 12 10]);
a=get(gca,'ylim'); a(1)=0; set(gca,'ylim',a);
plot([0 a(2)/R(1)],[0 a(2)],'k--');
plot([0 m],[R(1) R(1)],'k:');
text(32,610,'cardinality only','fontsize',fs)
text(3,1100,'size only','fontsize',fs)
text(30,1050,'actual curve','fontsize',fs)