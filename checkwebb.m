cp=1004.67;Ra=287.05;Mair=28.965e-3; Mwat=18.0153e-3;NP=101325;NT=273.15;
ro=MPstatic*100./(Ra*MT);
H2=H./ro/cp;
pa=interp1q(GPSTime, Pstatic, time');
mx=interp1q(GPSTime, r_Irga, time');
qa=pa*100*Mair/8.32./MT';

Fpw=1.61*Fw./qa';
Fpw=Fpw.*MN;
Fph=(1+1.61*mx'*0.001).*H2./MT.*MN;

plot(time, Fp, time, Fpw, time, Fph)
legend('Fp','Fpw','Fph')
figure
subplot(1,2,1)
plot(time, MU)
subplot(1,2,2)
plot(MU, Malt, '*')