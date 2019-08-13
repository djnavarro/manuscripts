
% read parameters
clist=[.3 .6 .9];% which confidence ellipses should we draw

% means
d=-20;
mu1=[80 80]+d;
mu2=[160 80]+d;
mu3=[80 160]+d;
mu4=[160 160]+d;
mu56=[120 120]+d;

% covariance matrices
cov1234=[20 20 0 ];
cov5=[10 50 0];
cov6=[50 10 0];

% useful constants and variables 
scf=250;
params=[ 
    mu1 cov1234;
    mu2 cov1234;
    mu3 cov1234;
    mu4 cov1234;
    mu56 cov5;
    mu56 cov6;
]/scf;


[np junk]=size(params); % number of parameters
labs=char('A3','A4','A1','A2','B1','B2'); % labels
step=.01; % granularity of the plot
xlist=[-1:step:1]; % x co-ordinates
ylist=[-1:step:1]; % y co-ordinates
[x,y]=meshgrid(xlist,ylist); % matrix forms (used in calculating z)

% ready the figure
figure(1);clf; cla; hold on; % clear and then hold the axis
%title([int2str(round(100*(clist))) '%'],'fontsize',14); % title tells you what confidence ellipses are plotted
%axis([-1 1 -1 1]); % axis limits
set(gca,'box','on'); % draw box
%axis square; % keep axes on the same scale

% colours
colA=[1 1 1]*.2;
colB=[1 1 1]*.5;
col=[repmat(colA,4,[]); repmat(colB,2,[])];

% label locations
lx=[0 0 0 0 0 80]/scf;
ly=[0 0 0 0 80 0]/scf;

% loop over the number of points (i.e., ships) in the display
for point=1:np;
	
    % rename as individual parameters (meanx,meany,stdx,stdy,corrcoef)
    mux=params(point,1); % mean x
    muy=params(point,2); % mean y
    sx=params(point,3); % standard deviation x
    sy=params(point,4); % standard deviation y
    rho=params(point,5); % correlation coefficient

    % generate bivariate Gaussian
    z=(x-mux).^2/sx^2-2*rho.*(x-mux).*(y-muy)/(sx*sy)+(y-muy).^2/sy^2;
    z=exp(-z/2/(1-rho^2));
    z=z/sum(sum(z));
    
    % unique values in density, and their encompassed volumes
    %%uv=unique(z); % OLD VERSION: unique values (all)
    uv=unique(max(z,.000001)); % unique values (truncated to avoid stupid values)
    enclosed=zeros(size(uv)); % corresponding volumes enclosed by those values
    for i=1:length(uv); % for all unique values ...
        enclosed(i)=sum(sum(z(find(z<=uv(i))))); % ... calculate enclosed volume
    end;

    % match to clist
    contourlist=zeros(size(clist));
    if ~isempty(clist)
        for i=1:length(clist)
            [val ind]=min(abs((1-clist(i))-enclosed));
            contourlist(i)=uv(ind);
        end;
    end;
    
    % draw label & contour
    th=text(mux+lx(point),muy+ly(point),labs(point,:),'vert','mid','hor','cen','fontsize',10,'fontweight','bold'); %label
    [ch,h]=contour(xlist,ylist,z,contourlist,'k'); % contour
    set(h,'linecolor',col(point,:),'linewidth',1.5);

end; % for point
set(gca,'xtick',[],'ytick',[]);
set(gcf,'paperunits','centimeters','paperposition',[1 1 11 11])
