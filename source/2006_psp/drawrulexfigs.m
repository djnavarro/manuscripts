% rulex figs

E1=[
    0.2110    0.3780    0.4590    0.4220    0.4720    0.4980
    0.0250    0.1560    0.2860    0.2950    0.3310    0.3410
    0.0030    0.0830    0.2230    0.2220    0.2300    0.2840
         0    0.0560    0.1450    0.1720    0.1390    0.2450
         0    0.0310    0.0810    0.1480    0.1060    0.2170
         0    0.0270    0.0780    0.1090    0.0810    0.1920
         0    0.0280    0.0630    0.0890    0.0670    0.1920
         0    0.0160    0.0330    0.0630    0.0780    0.1770
         0    0.0160    0.0230    0.0250    0.0480    0.1720
         0    0.0080    0.0160    0.0310    0.0450    0.1280
         0         0    0.0190    0.0190    0.0500    0.1390
         0    0.0020    0.0090    0.0250    0.0360    0.1170
         0    0.0050    0.0080    0.0050    0.0310    0.1030
         0    0.0030    0.0130         0    0.0270    0.0980
         0    0.0020    0.0090         0    0.0160    0.1060
         0         0    0.0130         0    0.0140    0.1060
         0         0    0.0080         0    0.0140    0.0780
         0         0    0.0060         0    0.0140    0.0770
         0         0    0.0090         0    0.0130    0.0780
         0         0    0.0030         0    0.0140    0.0610
         0         0    0.0050         0    0.0130    0.0580
         0         0         0         0    0.0090    0.0420
         0         0    0.0030         0    0.0110    0.0420
         0         0    0.0050         0    0.0080    0.0300
         0         0    0.0020         0    0.0080    0.0380];

E2=[    0.0769    0.3612    0.2875    0.2489    0.3573    0.4982
         0    0.0442    0.2135    0.2076    0.2679    0.4563
         0    0.0189    0.1218    0.1160    0.1570    0.3052
         0    0.0155    0.0756    0.0681    0.1050    0.2239
         0    0.0133    0.0535    0.0458    0.0799    0.1853
         0    0.0117    0.0400    0.0325    0.0641    0.1599
         0    0.0105    0.0310    0.0238    0.0532    0.1411
         0    0.0095    0.0245    0.0177    0.0452    0.1264
         0    0.0086    0.0198    0.0134    0.0390    0.1144
         0    0.0079    0.0163    0.0102    0.0342    0.1043
         0    0.0073    0.0136    0.0078    0.0303    0.0958
         0    0.0067    0.0114    0.0061    0.0271    0.0883
         0    0.0063    0.0098    0.0047    0.0245    0.0818
         0    0.0058    0.0085    0.0037    0.0222    0.0760
         0    0.0055    0.0074    0.0029    0.0203    0.0708
         0    0.0051    0.0065    0.0023    0.0187    0.0662
     ];

figure(1); clf; 
subplot(1,2,1); hold on; E=E1; nt=16^2; blocksize=16; ntick=4;
set(gca,'fontsize',8)
for i=1:6; plot([1:16]',E(1:16,i),'k-'); 
    text(round([1 nt/blocksize/ntick:nt/blocksize/ntick:nt/blocksize]),...
	E(round([1 nt/blocksize/ntick:nt/blocksize/ntick:nt/blocksize]),i),num2str(i),...
	    'verticalalignment','middle','horizontalalignment','center'); end
	xlabel('Learning Block','fontweight','bold'); 
	ylabel('Probability of Error','fontweight','bold');
	set(gca,'xlim',[0,nt/blocksize],'xtick',[0:nt/blocksize/ntick:nt/blocksize],...
	    'ylim',[0 .5 ],'ytick',[0:.1:1]);  
end

subplot(1,2,2); hold on; E=E2; nt=16^2; blocksize=16; ntick=4;
set(gca,'fontsize',8)
for i=1:6; plot([1:16]',E(1:16,i),'k-'); 
    text(round([1 nt/blocksize/ntick:nt/blocksize/ntick:nt/blocksize]),...
	E(round([1 nt/blocksize/ntick:nt/blocksize/ntick:nt/blocksize]),i),num2str(i),...
	    'verticalalignment','middle','horizontalalignment','center'); end
	xlabel('Learning Block','fontweight','bold'); 
	ylabel('Probability of Error','fontweight','bold');
	set(gca,'xlim',[0,nt/blocksize],'xtick',[0:nt/blocksize/ntick:nt/blocksize],...
	    'ylim',[0 .5 ],'ytick',[0:.1:1]);  
end

set(gcf,'paperunits','centimeters','paperposition',[1 1 16 8])

msz=3;
%ms=['o';'s';'x';'^';'d';'v'];
ms=['o';'o';'o';'s';'s';'s'];
load temp6; figure(2); clf; subplot(1,2,2); hold on
set(gca,'fontsize',8)
R=[(RSP+RWP+RWT) ;RDP+RDT]';
for i=1:1; plot([1:50]',R(1:50,i),'k-','marker','o','markerfacecolor','k','markersize',msz); end
for i=4:4; plot([1:50]',R(1:50,i),'k-','marker','o','markersize',msz); end
plot([1:50]',1-sum(R(1:50,:),2),'k--')
xlabel('Trial','fontweight','bold'); 
ylabel('Rule Maintenance','fontweight','bold');
set(gca,'xlim',[0,50],'xtick',[0:10:50],'ylim',[0 1],'ytick',[0:.25:1]);  
legend('single','conjunctive','no rule'); legend boxoff

ms=['o';'s';'x';'^';'s';'s'];
%ms=['o';'o';'o';'s';'s';'s'];
load temp2; subplot(1,2,1); hold on
set(gca,'fontsize',8)
R=[(RSP+RWP+RWT) ;RDP+RDT]';
for i=1:1; plot([1:50]',R(1:50,i),'k-','marker','o','markerfacecolor','k','markersize',msz); end
for i=4:5; plot([1:50]',R(1:50,i),'k-','marker',ms(i,:),'markersize',msz); end
plot([1:50]',1-sum(R(1:50,:),2),'k--')
xlabel('Trial','fontweight','bold'); 
ylabel('Rule Maintenance','fontweight','bold');
set(gca,'xlim',[0,50],'xtick',[0:10:50],'ylim',[0 1],'ytick',[0:.25:1]);  
legend('single','good conjunctive','bad conjunctive','no rule'); legend boxoff

set(gcf,'paperunits','centimeters','paperposition',[1 1 16 8])



