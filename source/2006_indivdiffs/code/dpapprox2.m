% approximate distributions sampled from the Dirichlet Process.

alpha=[100];
res=2000;
errcrit=10^-5;
figure(1); clf; 
x=[0:.001:.999];
lw=1.5;
fs=7;
yl2=.05

% parameters of the base distribution
A=10; B=2;

% pdf for the base distribution
y=betapdf(x,A,B);

% iid sample from the base distribution
theta=betarnd(A,B,res,1); % x~beta
	
% assign masses using stick(alpha)
pi_p=betarnd(1,alpha,res,1); % iid beta(1,alpha)
tmp=cumprod(1-pi_p); % find normalizing factor
pi=[pi_p(1); pi_p(2:end).*tmp(1:end-1)]; % multiply
	
% draw base distribution
subplot(3,2,1); hold on;
plot(x,y,'k-','linewidth',lw); drawnow;
yl=max(get(gca,'ylim'));
set(gca,'xlim',[0 1],'ylim',[0 6],'xtick',[0 1],'ytick',[0 6],'box','on','fontsize',fs);
xlabel('\theta');
ylabel('p(\theta|G_0)');

% draw sample distribution
subplot(3,2,2); hold on;
for i=1:res; plot([theta(i) theta(i)],[0,pi(i)],'k-'); end; drawnow;
yl=max(get(gca,'ylim'));
set(gca,'xlim',[0 1],'ylim',[0 yl2],'xtick',[0 1],'ytick',[0 yl2],'box','on','fontsize',fs);
xlabel('\theta');
ylabel('p(\theta|G)');



% parameters of the base distribution
A=1; B=1;

% pdf for the base distribution
y=betapdf(x,A,B);

% iid sample from the base distribution
theta=betarnd(A,B,res,1); % x~beta
	
% assign masses using stick(alpha)
pi_p=betarnd(1,alpha,res,1); % iid beta(1,alpha)
tmp=cumprod(1-pi_p); % find normalizing factor
pi=[pi_p(1); pi_p(2:end).*tmp(1:end-1)]; % multiply
	
% draw base distribution
subplot(3,2,3); hold on;
plot(x,y,'k-','linewidth',lw); drawnow;
yl=max(get(gca,'ylim'));
set(gca,'xlim',[0 1],'ylim',[0 6],'xtick',[0 1],'ytick',[0 6],'box','on','fontsize',fs);
xlabel('\theta');
ylabel('p(\theta|G_0)');

% draw sample distribution
subplot(3,2,4); hold on;
for i=1:res; plot([theta(i) theta(i)],[0,pi(i)],'k-'); end; drawnow;
yl=max(get(gca,'ylim'));
set(gca,'xlim',[0 1],'ylim',[0 yl2],'xtick',[0 1],'ytick',[0 yl2],'box','on','fontsize',fs);
xlabel('\theta');
ylabel('p(\theta|G)');

% parameters of the base distribution
A=10; B=1;

% pdf for the base distribution
y=betapdf(x,A,B)/2 + betapdf(x,B,A)/2;

% iid sample from the base distribution
theta=betarnd(A,B,res,1); % x~beta
tmp=round(rand(size(theta)));
theta=tmp.*theta + (1-tmp).*(1-theta);

	
% assign masses using stick(alpha)
pi_p=betarnd(1,alpha,res,1); % iid beta(1,alpha)
tmp=cumprod(1-pi_p); % find normalizing factor
pi=[pi_p(1); pi_p(2:end).*tmp(1:end-1)]; % multiply
	
% draw base distribution
subplot(3,2,5); hold on;
plot(x,y,'k-','linewidth',lw); drawnow;
yl=max(get(gca,'ylim'));
set(gca,'xlim',[0 1],'ylim',[0 6],'xtick',[0 1],'ytick',[0 6],'box','on','fontsize',fs);
xlabel('\theta');
ylabel('p(\theta|G_0)');

% draw sample distribution
subplot(3,2,6); hold on;
for i=1:res; plot([theta(i) theta(i)],[0,pi(i)],'k-'); end; drawnow;
yl=max(get(gca,'ylim'));
set(gca,'xlim',[0 1],'ylim',[0 yl2],'xtick',[0 1],'ytick',[0 yl2],'box','on','fontsize',fs);
xlabel('\theta');
ylabel('p(\theta|G)');

set(gcf,'paperunits','centimeters','paperposition',[1 1 12 12])