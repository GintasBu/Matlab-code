% Twin Otter flux, t=GPSTime, N=conc
% like TOfluxjn2 but additionally calculates water vapor flux
function [H,Fw,Fp,Fp2,Fpw, Fph, UW,UST,L,Su,Sv,Sw,ST,SN,MT,MU,WD,MN, Mqv,MPstatic, Mr_Irga, lagp, lagv,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, MSST,dT,Sroll, Spitch, Shead, Slat, Slong, Salt,SSST,sdT, Sqv, SPstatic,Sr_Irga, data, qv]=TOfluxjn2w(t,u,v,w,T,N,longitude, latitude, altitude, heading, pitch, roll, SST, r_Irga, Pstatic)

tttt=300; % time window for average & covar calculations
deltat=1; % step increase, normally =1

Ns=sum(isnan(N));
jn2=find(isnan(N)>0);

if Ns>0
    N(jn2)=[];
    t(jn2)=[];
    u(jn2)=[];
    v(jn2)=[];
    w(jn2)=[];
    T(jn2)=[];
    latitude(jn2)=[];
    longitude(jn2)=[];
    altitude(jn2)=[];
    heading(jn2)=[];
    pitch(jn2)=[];
    roll(jn2)=[];
    SST(jn2)=[];
    r_Irga(jn2)=[];
    Pstatic(jn2)=[];
display(' Ns>0')
end

t1=min(t); % FOR OTHER THAN 081006 FLIGHTS
%t1=t(8400); % for 081006 flight
t2=max(t);
t3a=t1;
t3=t3a+tttt;

tt=t;
uu=u;
vv=v;
ww=w;
TT=T;
NN=N;
ppitch=pitch;
rroll=roll;
hheading=heading;
llong=longitude;
llat=latitude;
aalt=altitude;
PPstatic=Pstatic;
rr_Irga=r_Irga;

clear t u v w T N longitude latitude altitude heading pitch roll jn2 Pstatic r_Irga

ii=1;
%reading Hz
f=20; 
%limits 1st guess for the time delay in the sampling line
plag=fix([0 15]*f);

cp=1004.67;
Ra=287.05;
Mair=28.965e-3; % Molecular weight of air
Mwat=18.0153e-3; % Molecular weight of water
NP=101325;
NT=273.15;

aaaa=100*PPstatic.*rr_Irga*0.001*Mwat/8.32;
qvqv=aaaa./TT./(rr_Irga*0.001+Mair/Mwat);   % in kg per m3
clear aaaa

while t3<t2,
    
jj1=find(abs(tt-t3a)==min(abs(tt-t3a)));
jj2=find(abs(tt-t3)==min(abs(tt-t3)));

jjj1(ii)=jj1;
jjj2(ii)=jj2;

t=tt(jj1:jj2);
u=uu(jj1:jj2);
v=vv(jj1:jj2);
w=ww(jj1:jj2);
T=TT(jj1:jj2);
N=NN(jj1:jj2);
qv=qvqv(jj1:jj2);
Pstatic=PPstatic(jj1:jj2);
r_Irga=rr_Irga(jj1:jj2);
lat=llat(jj1:jj2);
long=llong(jj1:jj2);
alt=aalt(jj1:jj2);
head=hheading(jj1:jj2);
pitch=ppitch(jj1:jj2);
roll=rroll(jj1:jj2);
sst0=SST(jj1:jj2);


jn=find(N<0); jnn=find(N>0);
N(jn)=mean(N(jnn));
clear jnn jn
jn=find(N>0);
    %break
    %end

% wind direction

U(ii)=mean(u(:));
V(ii)=mean(v(:));

wd = atan2(u,v)*180/pi+180;

WD(ii)=mean(wd);
% Fluxes and statistics
% change all Nser to N

%averages
u2=sqrt(u.*u+v.*v+w.*w);
MU(ii) = mean(u2(:));
MT(ii) = mean(T(:));
MN(ii) = mean(N(:));
time(ii)=mean(t(:));
Mroll(ii) = mean(roll(:));
Mpitch(ii) = mean(pitch(:));
Mlat(ii) = mean(lat(:));
Mlong(ii) = mean(long(:));
Malt(ii) = mean(alt(:));
Mhead(ii) = mean(head(:));
MSST(ii)=mean(sst0(:));
dT(ii)=mean(T(:)-sst0(:));
Mqv(ii)=mean(qv(:));
MPstatic(ii)=mean(Pstatic(:));
Mr_Irga(ii)=mean(r_Irga(:));
%detrengind linearly the data

%ud = detr2(jn,u);
%vd = detr2(jn,v);

%wd = detr2(jn,w);
Td = detr2(jn,T);
qvd= detr2(jn, qv);
Nd = detr2(jn,N);
%display('detrended, OK')
%standarddevations
Su(ii) = std(u(:));
Sv(ii) = std(v(:));
Sw(ii) = std(w(:));
ST(ii) = std(T(:));
SN(ii) = std(N(:));
Sroll(ii) = std(roll(:));
Spitch(ii) = std(pitch(:));
Slat(ii) = std(lat(:));
Slong(ii) = std(long(:));
Salt(ii) = std(alt(:));
Shead(ii) = std(head(:));
SSST(ii)=std(sst0(:));
sdT(ii)=std(T(:)-sst0(:));
Sqv(ii)=std(qv(:));
SPstatic(ii)=std(Pstatic(:));
Sr_Irga(ii)=std(r_Irga(:));

%calculate time delay in sampling line
siw=size(w);
siNd=size(Nd);
sijn=size(jn);
ii;
r = xcorrTO(w,Nd,plag(1),plag(2));
j=find(abs(r(:,2)) == max(abs(r(:,2))));
lagp(ii)=r(j,1); % Delay time for particles

%display('laged OK')
Fp(ii)=covar2(w,Nd,lagp);
Fp2(ii)=covar2(w,Nd,17);

%--------------------------water vapor flux section
rv = xcorrTO(w,qvd,plag(1),plag(2));
j=find(abs(rv(:,2)) == max(abs(rv(:,2))));
lagv(ii)=rv(j,1); % Delay time for water vapor

Fw(ii)=covar2(w,qvd,lagv);  
qa=MPstatic(ii)*100*Mair/8.32/MT(ii);
Fpw(ii)=1.61*Fw(ii)/qa;
Fpw(ii)=Fpw(ii)*MN(ii);
clear qa


% ------------------------ end of water vapor flux section

UW(ii) = covar2(w,u2,0);
ro=MPstatic(ii)*100./(Ra*MT(ii));
hh=covar2(w,Td,0);
H(ii) = cp*ro*hh; % in W/m^2
Fph(ii)=(1+1.61*Mr_Irga(ii)*0.001)*hh/MT(ii)*MN(ii);
clear hh
%display('fuxes OK')
if UW(ii) < 0
 UST(ii) = sqrt(-UW(ii));
 L(ii) = ro*UW(ii)*UST(ii)*MT(ii) / (0.4*9.8067*(H(ii)/cp)); % Monin-Obukhov length
else 
 UST(ii) = 0;
 L(ii) = 0; 
end
t3a=t3a+deltat;
t3=t3a+tttt;

clear jj1 jj2 t u v w T N ro r j roll pitch lat long alt head jn 
ii=ii+1;
end
data=time';
data(:,2)=Fp';
data(:,3)=Fp2';
data(:,4)=H';
data(:,5)=UST';
data(:,6)=UW';
data(:,7)=L';
data(:,8)=MN';
data(:,9)=MT';
data(:,10)=MU';
data(:,11)=WD';
data(:,12)=lagp';
data(:,13)=Malt';
data(:,14)=Mhead';
data(:,15)=Mroll';
data(:,16)=Mpitch';
data(:,17)=Mlong';
data(:,18)=Mlat';
data(:,19)=Su';
data(:,20)=Sv';
data(:,21)=Sw';
data(:,22)=SN';
data(:,23)=ST';
data(:,24)=Sroll';
data(:,25)=Spitch';
data(:,26)=Shead';
data(:,27)=Slat';
data(:,28)=Slong';
data(:,29)=Salt';
data(:,30)=MSST';
data(:,31)=SSST';
data(:,32)=dT';
data(:,33)=sdT';
data(:,34)=Fw';
data(:,35)=Mqv';
data(:,36)=Sqv';
data(:,37)=lagv';
data(:,38)=MPstatic';
data(:,39)=Mr_Irga';
data(:,40)=Fpw';
data(:,41)=Fph';
data(:,42)=Sr_Irga';

qv=qvqv;
%data(:,30)=jjj1(1:length(jjj1)-1)';
%data(:,31)=jjj2(1:length(jjj2)-1)';