% correct irga and calc thetav
function thetav=coorr(flightNo);

[filename, filepath]=uigetfile('*mat')
sp=['load ' filepath filename]
eval(sp)
clear sp 
Rv=461.51;
e=Pstatic.*r_Irga./(1000*0.622+r_Irga);
rhov=1000*e./(Rv.*T/100);
offset=[-0.23,0.63,0.82,0.53,-0.24,-0.24,0.02,0,0.71,4.02,0.33];
rhov=polyval([2.57,1.63],rhov-5)+offset(flightNo); 
e=(rhov/1000).*Rv.*T/100;
r_Irgaraw=r_Irga;
r_Irga=1000*0.622*e./(Pstatic-e);

plot(GPSTime, r_Irgaraw, GPSTime, r_Irga)
legend('raw' ,'corrected')

thetav=T.*(1+0.608*(r_Irga*0.001./(r_Irga*0.001+1))).*((1013./Pstatic).^0.286);
figure
plot(GPSTime, T, GPSTime, thetav,'g')
legend('T','thetav')
clear Rv e rhov offset 
sp=['save ' filepath filename]
eval(sp)