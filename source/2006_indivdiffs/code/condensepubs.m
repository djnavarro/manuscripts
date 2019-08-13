% produce interpretable publication analysis

% load the state of the gibbs sampler
load pubendstate

% initialise author loading matrix
na=size(pubdata,1);
nc=15;
AL=zeros(na,nc);

% learn author loadings
ns=5;
loc=2000
for i=loc-ns:loc
    disp(['adding sample ' num2str(i)]);
    drawnow
    g=GG(i,:);
    for j=1:nc;
        ind=find(g==j);
        if length(ind)>5;
            AL(ind,j)=AL(ind,j)+1;
        end
    end
end
nj=size(pubdata,2);
    

% find most prototypical authors
T=zeros(na,2,nc);
for i=1:nc;
    [y,j]=sort(AL(:,i));
    y=flipud(y);
    j=flipud(j);
    T(:,1,i)=y;
    T(:,2,i)=j;
end

% ignore base rates 
Z=X; % initialise
Z=Z./repmat(sum(Z+1,1),na,1); %for author
Z=Z./repmat(sum((Z+1),2),1,nj); % for journal

% rank journals for each group
JR=Z'*AL;

% find most prototypical journals
R=zeros(nj,2,nc);
for i=1:nc
    [y,j]=sort(JR(:,i));
    y=flipud(y);
    j=flipud(j);
    R(:,1,i)=y;
    R(:,2,i)=j;
end

% print out the most typical journals
for i=1:10
    disp(' ');
    disp(['------ cluster ' num2str(i) ' ------']);
    for j=1:nc
        disp(journals(R(j,2,i),:));
    end
end



