% check that gamma in matlab does what i think it does...
a=1;
b=2;

x=[.1:.1:20];
y1=x.^(a-1).*exp(-b*x);
y2=gampdf(x,a,1/b);
y1=y1/sum(y1);
y2=y2/sum(y2);

figure(1);clf; hold on;
plot(x,y1,'k-')
plot(x,y2,'ko')