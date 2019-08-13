% approximate distributions sampled from the Dirichlet Process.

alphas=[100 20 5];
res=1000;
errcrit=10^-5;
figure(1); clf; 

mp=1;
la=length(alphas);
mps=mp*la; 
pn=0;
for o=1:la;
for k=1:mp
    pn=pn+1;
    alpha=alphas(o);
    
	% iid sample from the base distribution
	theta=rand(res,1); % x~uniform
	
	% assign masses using stick(alpha)
	pi_p=betarnd(1,alpha,res,1); % iid beta(1,alpha)
	tmp=cumprod(1-pi_p); % find normalizing factor
	pi=[pi_p(1); pi_p(2:end).*tmp(1:end-1)]; % multiply
	
	% check
	chcksm=abs(1-sum(pi));
	if chcksm>errcrit; 
        warning('finite stick-breaking process missing mass greater than errcrit');
	end
	
	% draw
    subplot(mp,la,pn); hold on;
	for i=1:res;
        plot([theta(i) theta(i)],[0,pi(i)],'k-')
	end
    drawnow;
end
end

pn1=0; pn2=0;
for o=1:la;
yl=0;
% for i=1:mp;
%     pn1=pn1+1;
%     subplot(la,mp,pn1); 
%     yl=max(yl,max(get(gca,'ylim')));
% end
%yl=.25
for i=1:mp;
    pn2=pn2+1;
    subplot(mp,la,pn2); 
    yl=max(get(gca,'ylim'));
    set(gca,'xlim',[0 1],'ylim',[0 yl],'xtick',[0 1],'ytick',[0,yl],'box','on','fontsize',6);
    %set(gca,'xlim',[0 1],'xtick',[0 1],'box','on','fontsize',6);
    xlabel('\theta');
    ylabel('p(\theta|G)');
end
end
set(gcf,'paperunits','centimeters','paperposition',[1 1 15 4])