global days
global i
global xv
xv=[]; 
%load xv.dat
days=[80201 80303 80402 80504 80701 80801 80902 81001 81101 81201 81404 81501];

for i=1:12,
    d=num2str(days(i));
    if length(d)<6;
        d=['0' d]
    end
    
    dd=d(1:2);
    dd=str2num(dd);
    if dd<5,
        y='4'; else y='3';
    end
    
        cpath=['load c:\ocean2006\cabinfiles\\CABIN_06' d '.txt'];
eval(cpath);

scpc0=['CABIN_06' d];
l2cpc=sprintf('data=%s;', scpc0);
eval(l2cpc);
 clear scpc0 l2cpc
 
 

j=find(data==-9999);
data2=data;
data2(j)=NaN;

figure
plot(data2(:,1), data2(:,5), data2(:,1), data2(:,16),data2(:,1),data2(:,32))
grid


l=input('how many segments to select?    ')
for ii=1:l,
   
    %title(ii)
    aa=ginput(2);
    amin(ii)=floor(aa(1,1));
    amax(ii)=floor(aa(2,1));
    %clear aa
    %j1=find(abs(amin(ii)-100-data2(:,1))==min(abs(amin(ii)-100-data2(:,1))));
    %j2=find(abs(amax(ii)+100-data2(:,1))==min(abs(amax(ii)+100-data2(:,1))));
    %data2(j1:j2,:)=[];
    %  clear j1
    %  clear j2
    
    
    
end
s8=['save pa' d 's.mat amin amax'];
    eval(s8)
    clear s8
%subplot(2,1,1)

%plot(time,Fp,data2(:,1),data2(:,2),'.r')
%[f g]=size(data2);
%data3=zeros(f,1)+str2num(d);

%data3(:,2:g+1)=data2;
%xv=[xv' data3']';
%pause
clear 
global days
global i
global xv
end
%save xv.dat xv -ascii