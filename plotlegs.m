%function plotlegs(a,b,c,d)
Q=thetav(r_Irga, T, Pstatic);
subplot(2,2,1)
plot(Mlong(c:d)*180/pi,WD(c:d)); grid
title('WD')
subplot(2,2,2)
plot(Mlong(c:d)*180/pi,Fp3b(c:d),Mlong(c:d)*180/pi,H(c:d)*10); grid
legend('Fp', 'H*10')
subplot(2,2,3)
plot(longitude(a:b)*180/pi,conc(a:b)*10/16.67/2.35); grid
legend('conc')
subplot(2,2,4)
plot(longitude(a:b)*180/pi,Q(a:b)); grid
legend('Q')