% draw the plots for the model selection between mixture distributions

figure(1);clf;hold on;
x=[0:.01:1];
set(gcf,'paperunits','centimeters','paperposition',[1 1 15 13/3])

% 1-component model
subplot(1,3,1); hold on;
m1=.3; s1=.5; % mean & sd of the gaussian
y1= exp(-(1/s1^2)*(abs(x-m1)).^2); % find y
y=y1; y=y/sum(y); 
plot(x,y,'k-'); % draw

% 2-component model
subplot(1,3,2); hold on;
m1=.11; s1=.055; % mean & sd of gaussian 1
m2=.575; s2=.2; % mean & sd of gaussian 2
w1=.4; w2=1-w2; % mixing weights
y1= exp(-(1/s1^2)*(abs(x-m1)).^2); y1=y1/sum(y1); % find y1
y2= exp(-(1/s2^2)*(abs(x-m2)).^2); y2=y2/sum(y2); % find y2
y=w1*y1 + w2*y2; % mix & normalize
plot(x,y,'k-'); % draw

% 3-component model
subplot(1,3,3); hold on;
m1=.11; s1=.055;% mean & sd of gaussian 1
m2=.5; s2=.2; % mean & sd of gaussian 2
m3=.73; s3=.085; % mean & sd of gaussian 2
w1=.4; w2=.45; w3=1-w1-w2; % mixing weights
y1= exp(-(1/s1^2)*(abs(x-m1)).^2); y1=y1/sum(y1); % find y1
y2= exp(-(1/s2^2)*(abs(x-m2)).^2); y2=y2/sum(y2); % find y2
y3= exp(-(1/s3^2)*(abs(x-m3)).^2); y3=y3/sum(y3); % find y3
y=w1*y1 + w2*y2 + w3*y3; % mix & normalize
plot(x,y,'k-'); % draw

% set axis properties & draw in a hypothetical data set
d=[.08 .1 .11 .15  .4 .5 .6 .65 .7 .75 ];
fw='normal';
ym=0; for i=1:3; subplot(1,3,i); t=get(gca,'ylim'); ym=max([ym max(t)]); end
for i=1:3; subplot(1,3,i); 
    set(gca,'ylim',[0 ym],'box','on','xtick',[],'ytick',[]);
    xlabel('\theta','fontweight',fw);
    ylabel('pdf','fontweight',fw);
    plot(d,ones(size(d))*.0025,'kx');
end
