% draw distribution over alpha

% setup
maxalpha=90;
skp=.1;
ALPHA=[0:skp:maxalpha]; la=length(ALPHA);
%%ETA=[0:.05:1]; le=length(ETA); % relic of old method.
N=[10 1000 100000];
figure(1); clf; 
set(gcf,'paperunits','centimeters','paperposition',[1 1 14 18])
lnspc=['k--';'k: ';'k- ';'k-.'];

% over priors
for pr1=1:2
	
	% over n
	for j=1:3;
		
		% observed data
		n=N(j); % number of observations
		ahat=20; % "true alpha"
		k=round(ahat*(log(1+n/ahat))); % # observed groups
		
		% setup
		subplot(3,2,(j-1)*2 +pr1); hold on;
        set(gca,'fontsize',8);
		xlabel('\alpha');
		ylabel(['p(\alpha | k,n)']);
		
		% range of priors on alpha
        if pr1==1; % varying the shape of the prior
			G=[ 5 1;
               15 1;
               25 1;
               35 1];
        else % varying the scale of the prior
			G=[ 5 1;
                5 1/2.5;
                5 1/5;
                5 1/10];
        end
		
		for i=1:4;
            
%           % display on screen
%           disp([i,j,pr1])
 		
			% housekeeping
			%p=zeros(le,la); % clear matrix (relic of old method)
			pa=zeros(1,la); % clear matric
            a=G(i,1); % prior shape
			b=G(i,2); % prior scale

%           % an older, inefficient way of calculating things.
%           % it does match up to the new way within an acceptable
%           % tolerance for error.
% 			% looping...
% 			for ec=1:le; % over eta...
%                 eta=ETA(ec);
%                 for ac=1:la; % and alpha...
%                     alpha=ALPHA(ac);
%                     p(ec,ac)=beta(alpha+1,n)*(alpha+n)...
%                         *alpha^(a+k-2)*exp(-b*alpha); % joint prob
%                 end
% 			end
% 			pa=sum(p,1); % marginalise over eta
%             tmp=find(isnan(pa)); pa(tmp)=0; % a hack
%             tmp=find(isinf(pa)); pa(tmp)=0; % a hack
% 			pa=pa/sum(pa); % normalise
	
            % calculate probabilities
            for ac=1:la;
                alpha=ALPHA(ac);
                pa(ac)=alpha^(a+k-1)*exp(-b*alpha)*beta(alpha,n);
            end
            tmp=find(isnan(pa)); pa(tmp)=0; % hack to deal with machine tolerances
            tmp=find(isinf(pa)); pa(tmp)=0; % hack to deal with machine tolerances
            pa=pa/sum(pa); % normalise
            pa=la*pa/maxalpha; % renormalise
            
            % draw pics
            plot(ALPHA,pa,deblank(lnspc(i,:)),'linewidth',1);
            set(gca,...
                'xlim',[0 50],...
                'ylim',[0 .3],...
                'ytick',[0:.1:.3],...
                'yticklabel',[' 0';'.1';'.2';'.3'],...
                'box','on');            
            drawnow
		
		end
        
        % legend
        if pr1==1; % when varying the shape of the prior
            legh=legend('a=5, b=1','a=15, b=1','a=25, b=1','a=35, b=1');
        else % when varying the scale of the prior
            legh=legend('a=5, b=1','a=5, b=0.4','a=5, b=0.2','a=5, b=0.1');
        end
        set(legh,'fontsize',6)
        legend boxoff
        
	end
end
    
    
%check that the gibbs sampler lines up with the prediction: it does
%load data_k5_n50; nbins=100;
%[h,x]=hist(A(1:40000),nbins); h=h/40000/5;
%plot(x,h,'ko','linewidth',2);