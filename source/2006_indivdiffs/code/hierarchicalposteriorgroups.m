% posterior over groups
N=25;
A=[.005:.01:100];
na=length(A);

% check that gamma in matlab does what i think it does...
a=10^-10; % prior shape
b=10^-10; % prior scale
pA=gampdf(A,a,1/b);
pA=pA./sum(pA);
PP=zeros(N);

for ii=1:na
    alpha=A(ii);

    % find stirling numbers
    S=eye(N+1);
    for n=1:N;
        for k=1:n;
            S(n+1,k+1)=S(n,k)-(n-1)*S(n,k+1); % recurrence
        end
    end

    % find unsigned stirling numbers 
    Z=abs(S(2:end,2:end));

    % find posteriors
    P=zeros(N);
    for n=1:N;
        for k=1:n;
            P(n,k)=Z(n,k)*(alpha^k); % posterior
        end
        P(n,:)=P(n,:)/sum(P(n,:)); % normalize
    end

    % transpose matrix so I can think properly
    P=P';
    PP=PP+pA(ii)*P;
end
P=PP;    

% draw picture
figure(1); clf; hold on;
for i=1:N; 
    for j=1:N;
        if P(i,j)~=0;
            s=P(i,j)^.5;
            rectangle('position',[j-s/2,i-s/2,s,s],'edgecolor','w','facecolor','k');
        end
    end
end

% edit pic
fs=6;
xlabel('sample size, n','fontsize',fs)
ylabel('number of groups, k','fontsize',fs)
eps=.03;
axis equal
xl=N;
yl=20;
set(gca,'xtick',[1:25],'ytick',[1:25],'xlim',[.5-eps xl+.5+eps],'ylim',[.5-eps yl+.5+eps],'box','on','fontsize',fs);
q=1.2;
set(gcf,'paperunits','centimeters','paperposition',[1 1 10*q 7*q])

% printt pic
print -depsc2 mixdpgrow


