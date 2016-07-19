function newT=check(day, l1, l2),
lambda1=1.15;
lambda2=0.09;
A=0.3; B=1-A;

k1=1/lambda1;
k2=1/lambda2;

alfa=k1*A+k2*B;
beta=(k1+k2)/alfa-k1*k2/alfa/alfa;
gama=k1*k2/alfa;


%[filename, filepath]=uigetfile;
s2=['load c:\ocean2006\fluxes\AOSN\\xwiflux200' num2str(day) sprintf('T200.mat')];
eval(s2);
%s4=['data=' filename(1:length(filename)-4) ';' ];
%eval(s4)
%l1=4608;
%l2=4919;
j1=find(abs(GPSTime-GPSTime(1)-l1)==min(abs(GPSTime-GPSTime(1)-l1)));
j2=find(abs(GPSTime-GPSTime(1)-l2)==min(abs(GPSTime-GPSTime(1)-l2)));
I=0;
dTm=T(j1-50:j2+3)-T(j1-50);
t=GPSTime(j1:j2)-GPSTime(j1);
for k=2:j2-j1+50,
    I(k)=exp(-gama*0.1)+0.5*0.1*(exp(-gama*0.1)*dTm(k-1)+dTm(k));
    dTa(k)=0.5/alfa/0.1*(dTm(k+1)-dTm(k-1))+beta*dTm(k)+gama*(1-beta)*I(k);
end
Tacor=dTa+T(j1-50);
%plot(T(j1:j2)-284.3)
%hold on
%plot(Tacor(51:length(Tacor))-283.6,'r')
%hold off
newT=Tacor(51:length(Tacor));    