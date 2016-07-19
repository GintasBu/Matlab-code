% this script choses a segment of flight between MT l1 and l2. Then plots 
% lat long for the entire flight and the segment.
% plots conc and T for the segment and does FFT for the segment data
% Gintas, september 2004



function [j1, j2]=check(day, l1, l2),
l1=floor(l1); l2=floor(l2);
%[filename, filepath]=uigetfile;
s2=['load c:\ocean2006\fluxes\\xwflux20060' num2str(day) sprintf('T200.mat')];
eval(s2);
%s4=['data=' filename(1:length(filename)-4) ';' ];
%eval(s4)
%l1=4608;
%l2=4919;
Tn=T;

%2003 data
%j1=find(abs(GPSTime-GPSTime(1)-l1)==min(abs(GPSTime-GPSTime(1)-l1)));
%j2=find(abs(GPSTime-GPSTime(1)-l2)==min(abs(GPSTime-GPSTime(1)-l2)));
%2006 data
j1=find(abs(GPSTime-l1)==min(abs(GPSTime-l1)));
j2=find(abs(GPSTime-l2)==min(abs(GPSTime-l2)));

subplot(3,3,1)
plot(GPSTime(j1:j2),w(j1:j2))
xlabel('time,s')
grid
ylabel('Vertical wind speed, m/s')
title([num2str(day) ': ' num2str(l1) '  ' num2str(l2)])
subplot(3,3,9)

plot(longitude/pi*180,latitude/pi*180,'.',longitude(j1:j2)/pi*180,latitude(j1:j2)/pi*180,'o')
grid
xlabel('^oLongitude')
ylabel('^oLatitude')
subplot(3,3,3)
conc=conc;
wind=sqrt(v.*v+u.*u+w.*w);

plot(GPSTime(j1:j2),conc(j1:j2),GPSTime(j1:j2),wind(j1:j2)*1000,'r' )
ylabel('Aerosol concentration, #cm^-^3')
xlabel('time, s')
title('blue-conc, red-windspeed*1000')
grid
subplot(3,3,2)
plot(GPSTime(j1:j2),T(j1:j2),'b',GPSTime(j1:j2),SST(j1:j2),'r')
ylabel('Temperature, K')
xlabel('time, s')
title('red-SST, blue-T')
grid
xxx=[0.1 10];
yyy=xxx.^(-2/3)*1e3;
yyc=xxx.^(-4/3)*1e3;


x=fix(log(j2-j1)/log(2));
p=spectrum1109(w(j1:j2),Tn(j1:j2),2^x,20);
p2=spectrum1109(w(j1:j2),conc(j1-33:j2-33),2^x,20);

%newT=algor(day, l1, l2);
%pn=spectrum1109(w(j1:j2),T,2^x,20);


A=mean(altitude(j1:j2));

mar1=find(p(1,:)>0.05*A/55);
mar2=find(p2(1,:)>0.05*A/55);
size(p);

my4=find(p(2,mar1:70).*p(1,mar1:70)==max(p(2,mar1:70).*p(1,mar1:70)));
y4=p(2,my4)*p(1,my4);
my5=find(p(3,mar1:length(p))==max(p(3,mar1:length(p))));
y5=p(3,my5);
my6=find(p2(3,mar2:length(p2))==max(p2(3,mar2:length(p2))));
y6=p2(3,my6);
my7=find(p(4,mar1:length(p))==max(p(4,mar1:length(p))));
y7=p(4,my7);
my8=find(p2(4,mar2:length(p2))==max(p2(4,mar2:length(p2))));
y8=p2(4,my8);


subplot(3,3,4)
loglog(p(1,:)*A/55,p(2,:),'*',xxx,yyy*5)
ylabel('w power spectrum * frequency')
xlabel('norm. frequency')
axis([0.001 10 100 100000])
grid
subplot(3,3,5)
loglog(p(1,:)*A/55,p(3,:),'*',xxx,yyy*5) %,pn(1,:)*A/55,pn(3,:),'o')
ylabel('T power spectrum * frequency')
xlabel('norm. frequency')
%title('star-raw, circle-corrected')
axis([0.001 10 100 100000])
grid
subplot(3,3,6)
loglog(p2(1,:)*A/55,p2(3,:),'*',xxx,yyy*5)
ylabel('c power spectrum * frequency')
xlabel('norm. frequency')
axis([0.001 10 10 100000])
grid
subplot(3,3,7)
loglog(p(1,:)*A/55,p(4,:),'*r',p(1,:)*A/55,-p(4,:),'ob',xxx,yyc*50)
ylabel('Tw cospectra * frequency')
xlabel('norm. frequency')
grid
title('circle-neg, star-pos')
axis([0.0001 1000 1 6000000])
subplot(3,3,8)

loglog(p2(1,:)*A/55,p2(4,:),'*r',p2(1,:)*A/55,-p2(4,:),'ob',xxx,yyc*30)
grid
ylabel('cw cospectra * frequency')
xlabel('norm.frequency')
title('')
axis([0.0001 10 100 6000000])
orient landscape

clear w conc p2

orient landscape


%s2=['load c:\ocean\fluxes\\xnflux200speedJKall' num2str(day) sprintf('T200.mat')];
%eval(s2);

%p2=spectrum1109(w(j1:j2),conc(j1-33:j2-33),2^x,20);
%subplot(3,3,6)
%hold on
%loglog(p2(1,:)*A/55,p2(3,:),'o',xxx,yyy*5)
%hold off
%title('circle-speed,star-orig')
%subplot(3,3,8)
%hold on
%loglog(p2(1,:)*A/55,p2(4,:),'or',p2(1,:)*A/55,-p2(4,:),'ob',xxx,yyc*30)
%hold off
%title('circle-speed,star-orig&r+b-')
%axis([0.01 10 20 100000])