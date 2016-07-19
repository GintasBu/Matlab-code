
xv=[]; 
%load xv.dat
%days2=[80201 80303 80402 80504 80701 80801 80902 81001 81101 81201 81501]; % for 2006
%days=[121602 120501 111802 102801 100901 092503 090801 090501 090409 082904 031401 021904 021701 020402 012701 010502];%
days2=[ 80402 80504 80701 80201 80801 80902 81001 81101 81501];
for iii=1:3, %length(days2),
    %global days
    %global i
    %global xv
    d=num2str(days2(iii));
    if length(d)<6;
        d=['0' d]
    end
    
    dd=d(1:2);
    dd=str2num(dd);
    if dd<5,
        y='4'; else y='3';
    end
    
        cpath=['load c:\ocean2006\fluxes\\xwiflux2006' d 'T200.mat'];
eval(cpath);

j=find(Malt>45 | SN./MN>0.25 | UST<0.2);
%j=find(Malt>45);
j3=[j, j-100, j+100];
jx=find(j3>length(Malt) | j3<1);
j3(jx)=[];
clear jx j
j=j3;
clear j3
data2=data;
data2(j,:)=[];
clear j
%j2=find(data2(:,22)./data2(:,8)>0.2);

%data2(j2,:)=[];
size(data2)
figure(1)
subplot(3,1,1)
plot(time,Fp,data2(:,1),data2(:,2),'.')
ylabel('Fp &Fp SN<100000')
grid
title(d)
subplot(3,1,2)
plot(GPSTime,conc,data2(:,1),data2(:,22),data2(:,1),data2(:,8))
%legend('conc1s', 'SN', 'MN' )
grid
subplot(3,1,3)
plot(time,SN./MN)
legend('SN/MN')
grid
figure
plot3(Mlong*180/pi, Mlat*180/pi,Fp2,data2(:,17)*180/pi,data2(:,18)*180/pi,data2(:,3),'.',data2(:,17)*180/pi,data2(:,18)*180/pi,zeros(length(data2(:,3)),1),'.')
axis([-122.8 -121.8 36.6 37.3 -5 4])
grid
l=input('how many peaks to be removed?    ')

%l=1; 
for ii=1:l,
   
    title(ii)
    subplot(3,1,2)
    pause
    aa=ginput(2);
    amin(ii)=aa(1,1)
    amax(ii)=aa(2,1)
    clear aa
    j1=find(abs(amin(ii)-data2(:,1))==min(abs(amin(ii)-data2(:,1))))
    j2=find(abs(amax(ii)-data2(:,1))==min(abs(amax(ii)-data2(:,1))))
    
    data2(j1:j2,:)=[];
      clear j1
      clear j2
    
end
figure(2)
%subplot(2,1,1)

plot(time,Fp,data2(:,1),data2(:,2),'.r')
axis([min(time) max(time) -5 5])
grid
[f g]=size(data2);
data3=zeros(f,1)+str2num(d);

data3(:,2:g+1)=data2;
xv=[xv' data3']';
pause
 
%global days
%global i
%global xv
clear d dd y cpath j data data2 data3 aa amin amax f g 
end
%save xv.dat xv -ascii
