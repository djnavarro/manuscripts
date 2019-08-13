% draw nosofsky plots

% means
mu1=[80 80];
mu2=[160 80];
mu3=[80 160];
mu4=[160 160];
mu56=[120 120];

% covariance matrices
cov1234=[20 0; 0 20];
cov5=[10 0; 0 50];
cov6=[50 0; 0 10];

% co-ords
x=[0:2:240]; nx=length(x);
y=[0:2:240]; ny=length(y);

% get density 1
px=normpdf(x,mu1(1),cov1234(1,1));
py=normpdf(y,mu1(2),cov1234(2,2));
p1=repmat(px,ny,1).*repmat(py',1,nx);

% get density 2
px=normpdf(x,mu2(1),cov1234(1,1));
py=normpdf(y,mu2(2),cov1234(2,2));
p2=repmat(px,ny,1).*repmat(py',1,nx);

% get density 3
px=normpdf(x,mu3(1),cov1234(1,1));
py=normpdf(y,mu3(2),cov1234(2,2));
p3=repmat(px,ny,1).*repmat(py',1,nx);

% get density 4
px=normpdf(x,mu4(1),cov1234(1,1));
py=normpdf(y,mu4(2),cov1234(2,2));
p4=repmat(px,ny,1).*repmat(py',1,nx);

% get density 5
px=normpdf(x,mu56(1),cov5(1,1));
py=normpdf(y,mu56(2),cov5(2,2));
p5=repmat(px,ny,1).*repmat(py',1,nx);

% get density 6
px=normpdf(x,mu56(1),cov6(1,1));
py=normpdf(y,mu56(2),cov6(2,2));
p6=repmat(px,ny,1).*repmat(py',1,nx);

% make the two category densities
pA=(p1+p2+p3+p4)/4;
pB=(p5+p6)/2;

% draw figure
figure(1);clf; hold on; 
a1=.6; a2=.5;
c1=.3; c2=.7;
ind=[1:2:nx];
h1=surf(x,y,pA);
h2=surf(x,y,pB);
h3=surf(x(ind),y(ind),pA(ind,ind));
h4=surf(x(ind),y(ind),pB(ind,ind));
set(h1,'facecolor',[1 1 1]*c1,'facealpha',a1,'edgealpha',0);
set(h2,'facecolor',[1 1 1]*c2,'facealpha',a1,'edgealpha',0);
set(h3,'facecolor',[1 1 1]*c1,'facealpha',0,'edgealpha',a2);
set(h4,'facecolor',[1 1 1]*c2,'facealpha',0,'edgealpha',a2);

view(30,60);
set(gca,'visible','off')
set(gcf,'paperunits','centimeters','paperposition',[1 1 8 7])
%print -depsc2 -r300 catpic