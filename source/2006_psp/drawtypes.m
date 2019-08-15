
% draw figure 2(a) for the psp paper
s=[0 0 0; 0 0 1; 0 1 0; 0 1 1; 1 0 0; 1 0 1; 1 1 0; 1 1 1]; % stimuli
e=[1 2; 1 3; 1 5; 2 4; 2 6; 3 4; 3 7; 4 8; 5 6; 5 7; 6 8; 7 8]; % edges
lab=['I  ';'II ';'III';'IV ';'V  ';'VI ']; % roman numerals for types
c1=[1 2 3 4; 1 2 7 8; 1 2 3 6; 1 2 3 5; 1 2 3 8; 1 4 6 7];
c2=[5 6 7 8; 3 4 5 6; 4 5 7 8; 4 6 7 8; 4 5 6 7; 2 3 5 8];

figure(1);
ms=12; s1=8;s2=12; % marker sizes
b=[-.3 1.3]; % scale
for t=1:6;
    subplot(3,3,t); cla; hold on; % initialise axes
    plot3(s(c1(t,:),1),s(c1(t,:),2),s(c1(t,:),3),'ko','markersize',ms,'markerfacecolor',[1 1 1]); % plot cat1 markers
    plot3(s(c2(t,:),1),s(c2(t,:),2),s(c2(t,:),3),'ko','markersize',ms,'markerfacecolor',[.4 .4 .4]); % plot cat2 markers
    for i=1:length(e);
        plot3(s(e(i,:),1),s(e(i,:),2),s(e(i,:),3),'k:'); % draw edges
    end
    str=['Type ' deblank(lab(t,:))]; % label string
    text(.3,-1,0,str,'fontsize',6); % place label
    set(gca,'xlim',b,'ylim',b,'zlim',b); % shrink the cubes to a reasonable size
    view(13,34); % move camera
    set(gca,'visible','off'); % hide axes
end

% show dimensions
% subplot(3,3,7); hold on; % initialise axes
% for i=1:3;
%     plot3(s(e(i,:),1),s(e(i,:),2),s(e(i,:),3),'k-'); % draw edges
% end
% set(gca,'xlim',b,'ylim',b,'zlim',b); % shrink the cubes to a reasonable size
% view(13,34); % move camera
% set(gca,'visible','off'); % hide axes

% show stimuli
subplot(3,3,8); cla; hold on; % initialise axes
for i=1:length(e);
    plot3(s(e(i,:),1),s(e(i,:),2),s(e(i,:),3),'k:'); % draw edges
end
col=['k';'w';'k';'w';'k';'w';'k';'w';];
sz=[s1;s1;s2;s2;s1;s1;s2;s2];
mk=['^';'^';'^';'^';'s';'s';'s';'s'];
for i=1:8;
    plot3(s(i,1),s(i,2),s(i,3),'k.','markersize',sz(i),'marker',mk(i),'markerfacecolor',col(i));
end
set(gca,'xlim',b,'ylim',b,'zlim',b); % shrink the cubes to a reasonable size
view(13,34); % move camera
set(gca,'visible','off'); % hide axes

% show stimuli
subplot(3,3,9); cla; hold on; % initialise axes
for i=1:length(e);
    plot3(s(e(i,:),1),s(e(i,:),2),s(e(i,:),3),'k:'); % draw edges
end
col=['k';'k';'k';'k';'w';'w';'w';'w'];
sz=[s1;s2;s1;s2;s1;s2;s1;s2];
mk=['s';'s';'^';'^';'s';'s';'^';'^'];
for i=1:8;
    plot3(s(i,1),s(i,2),s(i,3),'k.','markersize',sz(i),'marker',mk(i),'markerfacecolor',col(i));
end
set(gca,'xlim',b,'ylim',b,'zlim',b); % shrink the cubes to a reasonable size
view(13,34); % move camera
set(gca,'visible','off'); % hide axes

