% Twin Otter flux, t=GPSTime, N=conc
function [H,Fp,Fp2,UW,UST,L,Su,Sv,Sw,ST,SN,MT,MU,WD,MN,lagp,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, MSST,dT,Sroll, Spitch, Shead, Slat, Slong, Salt,SSST,sdT,data]=TOflux(t,u,v,w,T,N,longitude, latitude, altitude, heading, pitch, roll, SST)

tttt=200; % time window for average & covar calculations
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
    
display(' Ns>0')
end

t1=min(t);
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


clear t u v w T N longitude latitude altitude heading pitch roll jn2

ii=1;
%reading Hz
f=10; 
%limits 1st guess for the time delay in the sampling line
plag=fix([0 15]*f);

cp=1004.67;
Ra=287.05;
Mair=28.965e-3; % Molecular weight of air
Mwat=18.0153e-3; % Molecular weight of water
NP=101325;
NT=273.15;

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

lat=llat(jj1:jj2);
long=llong(jj1:jj2);
alt=aalt(jj1:jj2);
head=hheading(jj1:jj2);
pitch=ppitch(jj1:jj2);
roll=rroll(jj1:jj2);
sst0=SST(jj1:jj2);


jn=find(N>0);

    %break
    %end

% wind direction

U(ii)=mean(u(jn));
V(ii)=mean(v(jn));

wd = atan2(u,v)*180/pi+180;

WD(ii)=mean(wd);
% Fluxes and statistics
% change all Nser to N

%averages
u2=sqrt(u.*u+v.*v+w.*w);
MU(ii) = mean(u2(jn));
MT(ii) = mean(T(jn));
MN(ii) = mean(N(jn));
time(ii)=mean(t(jn));
Mroll(ii) = mean(roll(jn));
Mpitch(ii) = mean(pitch(jn));
Mlat(ii) = mean(lat(jn));
Mlong(ii) = mean(long(jn));
Malt(ii) = mean(alt(jn));
Mhead(ii) = mean(head(jn));
MSST(ii)=mean(sst0(jn));
dT(ii)=mean(T(jn)-sst0(jn));
%detrengind linearly the data

%ud = detr2(jn,u);
%vd = detr2(jn,v);

%wd = detr2(jn,w);
Td = detr2(jn,T);

Nd = detr2(jn,N);
%display('detrended, OK')
%standarddevations
Su(ii) = std(u(jn));
Sv(ii) = std(v(jn));
Sw(ii) = std(w(jn));
ST(ii) = std(T(jn));
SN(ii) = std(N(jn));
Sroll(ii) = std(roll(jn));
Spitch(ii) = std(pitch(jn));
Slat(ii) = std(lat(jn));
Slong(ii) = std(long(jn));
Salt(ii) = std(alt(jn));
Shead(ii) = std(head(jn));
SSST(ii)=std(sst0(jn));
sdT(ii)=std(T(jn)-sst0(jn));

%calculate time delay in sampling line
size(w);
size(Nd);
size(jn);
ii
r = xcorrTO(w(jn),Nd,plag(1),plag(2));
j=find(abs(r(:,2)) == max(abs(r(:,2))));
lagp(ii)=r(j,1) % Delay time for particles

%display('laged OK')
Fp(ii)=covar2(w(jn),Nd,lagp);
Fp2(ii)=covar2(w(jn),Nd,33);

UW(ii) = covar2(w,u2,0);
ro=NP/(Ra*MT(ii));
H(ii) = cp*ro*covar2(w,Td,0); % in W/m^2
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
%data(:,30)=jjj1(1:length(jjj1)-1)';
%data(:,31)=jjj2(1:length(jjj2)-1)';