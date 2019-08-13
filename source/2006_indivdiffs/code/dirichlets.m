% draw Dirichlet distributions.


figure(1); clf; hold on;
xv=[.001:.01:.998];
a=2;
nxv=length(xv);
X=0*ones(nxv,nxv); 
for x1=1:nxv;
for x2=1:nxv-x1;
    x3=nxv-x2-x1;
    z=1-xv(x1)-xv(x2);
    x=[xv(x1) xv(x2) z];
    %ind1=round((x(2)+x(3))*nxv + (1-x(2)-x(3))*x1);
    %ind2=x2+x3;
    h=sqrt(3)/2;
    ind1=round(x1+.5*x2);
    ind2=round(h*x2);
    if x(1)+x(2)<=1;
        X(ind2,ind1)=prod(x.^(a-1));
    end
end;
end;

cmap=colormap('gray');
cmap=1-cmap;
colormap(cmap)
X=X./sum(sum(X));
skp=3;
Z=X(1:skp:end,1:skp:end);
Y=zeros(size(X));
q=10^-6;
for i=1:nxv; for j=1:nxv; 
        if X(i,j)==0; X(i,j)=0/0; Y(i,j)=q; end
end; end
surf(X,'edgecolor','interp','facecolor','interp'); 
%surf(X,'edgealpha',0,'edgecolor','interp','facecolor','interp'); 
u=[1:skp:size(X,1)];
%surf(u,u,Z,'facealpha',0,'edgealpha',.4); 
Y=[q*ones(nxv,1) Y q*ones(nxv,1)];
Y=[q*ones(1,nxv+2);Y; q*ones(1,nxv+2)];
%mesh(Y,'facecolor','w','edgecolor','w','facealpha',1,'edgealpha',1);
xlabel('ind1')
ylabel('ind2')
plot3([2.5 nxv-1],[2.5 2.5],[1 1],'k-','linewidth',2);
plot3([2.5 nxv/2],[2.5 nxv*h],[1 1],'k-','linewidth',2);
plot3([nxv/2 nxv-1],[nxv*h 2.5],[1 1],'k-','linewidth',2);


%view(65.3816 ,0.000275371)
axis equal
%set(gca,'visible','off')
set(gca,'xlim',[2 nxv-1],'ylim',[2 nxv*h+1])
set(gcf,'paperunits','centimeters','paperposition',[1 1 5 5])
print -depsc dir1 
