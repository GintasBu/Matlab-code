function Q=thetav(r_irga,T, Pstatic)
% calculates virtual potential temperature
Q=T.*(1+0.608*(r_irga*0.001./(r_irga*0.001+1))).*((1013./Pstatic).^0.286);