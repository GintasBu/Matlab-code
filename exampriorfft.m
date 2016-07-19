global days
global i
global xv
xv=[]; 
%load xv.dat
days=[80201 80303 80402 80504 80701 80801 80902 81001 81101 81201 81404 81501];

for i=12:12,
    d=num2str(days(i));
    if length(d)<6;
        d=['0' d]
    end
    
    dd=d(1:2);
    dd=str2num(dd);
    if dd<5,
        y='4'; else y='3';
    end
    
        cpath=['load c:\ocean2006\fluxes\\xwflux2006' d 'T200.mat'];
eval(cpath);

j=find(SN>100000);
data2=data;
data2(j,:)=[];

subplot(3,1,1)
plot(time,Fp,data2(:,1),data2(:,2),'.')
grid
title(d)
subplot(3,1,2)
plot(GPSTime,conc,'b',time,Malt*100,'r',time,SN*1,'g',time,MN,'k')
title('b-conc, r-alt*100, g-SN, black-MN')
grid
subplot(3,1,3)
plot(time,SN./MN)
grid
figure
plot(GPSTime, heading+180, GPSTime, altitude)
grid
l=input('how many segments to select?    ')
for ii=1:l,
   
    %title(ii)
    aa=ginput(2);
    amin(ii)=aa(1,1);
    amax(ii)=aa(2,1);
    %clear aa
    %j1=find(abs(amin(ii)-100-data2(:,1))==min(abs(amin(ii)-100-data2(:,1))));
    %j2=find(abs(amax(ii)+100-data2(:,1))==min(abs(amax(ii)+100-data2(:,1))));
    %data2(j1:j2,:)=[];
    %  clear j1
    %  clear j2
    
    
    
end
s8=['save sa' d 's.mat amin amax'];
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
