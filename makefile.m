days=[72603, 80102, 80201, 80303, 80402, 80504, 80701, 80801, 80902, 81001, 81101, 81201, 81404, 81501];

for i=2:length(days),
    %i=26;
    d=num2str(days(i));
    %if length(d)=5, d=[0 d]; end
    s2=['load c:\ocean2006\cabinfiles\\cabin_060' d(1:5) '.txt'];
    eval(s2);
    s3=['data=cabin_060' d ';'];
    eval(s3);
    clear s2 s3
    [l w]=size(data);
    dat=zeros(l,10);
    dat(:,1)=data(:,1);     %MT
    dat(:,2)=-data(:,4);    %long
    dat(:,3)=data(:,3);     %lat
    dat(:,4)=data(:,5);     %alt cmigit
    dat(:,5)=data(:,20)-data(:,12);    %SST-T
    %dat(:,6)=data(:,20);    %SST
    dat(:,6)=data(:,18);    %wind speed
    dat(:,7)=data(:,17);     %wind direction
    if w>27,  
        dat(:,8)=data(:,30); % cabin CPC
        dat(:,9)=data(:,28)/2.35; % flux CPC
        dat(:,10)=data(:,32);   %Ralt
    else dat(:,8)=NaN;   
         dat(:,9)=NaN;  
         dat(:,10)=NaN;  
    end    
    
    kk=find(dat==-9999);
    dat(kk)=NaN;
    
    s6=['save C:\ocean2006\latlong\\af20060' d '.dat dat -ascii'];
    eval(s6)
    d
    clear dat data s6 d 
end
