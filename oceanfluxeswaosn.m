 global days
global i
%days=[120302 120303 111802 100901 092503 090801 090409 082904  031401 020402 012701 010502 121602 120501 102801  090501 021701 ]; %082501 082203 082106 082003 081501 081304 081101 081003 080602];
%days=[082904 090501 090801 100901 092503 090409 031401 020402 012701 010502 121602 120501 102801]; %082501 082203 082106 082003 081501 081304 081101 081003 080602];
days=[120302 120303]
for i=1:2, %length(days),
    d=num2str(days(i));
    if length(d)<6;
        d=['0' d]
    end
    
    dd=d(1:2);
    dd=str2num(dd);
    if dd<5,
        y='4'; else y='3';
    end
 
        cpath=['load c:\ocean2006\turbulence2003\' d '\\Gnmeteo200' y d '10Hz'];
eval(cpath);

%[H,Fp,Fp2,UW,UST,L,Su,Sv,Sw,ST,SN,MT,MU,WD,MN,lagp,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, Sroll, Spitch, Shead, Slat, Slong, Salt,data]=TOflux(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll);
[H,Fw,Fp,Fp2,Fp3, Fp3b, Fpw, Fph, UW,UST,L,Su,Sv,Sw,ST,SN, SNi,MT,MU,WD,MN, Mqv,MPstatic, Mr_Irga, lagp, lagpi, lagv,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, MSST,dT,Sroll, Spitch, Shead, Slat, Slong, Salt,SSST,sdT, Sqv, SPstatic,Sr_Irga, data, qv]=TOfluxjn2waosn(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll, SST, r_Irga, Pstatic);
spath=['save c:\ocean2006\fluxes\AOSN\\xwiflux200' y d 'T200.mat -mat'];   % the same as xnflux2006 plus water vapor flux
eval(spath);
dpath=['save c:\ocean2006\fluxes\AOSN\\xwniata200' y d 'T200.dat data -ascii'];    % the same as xnata2006 plus water vapor flux
eval(dpath);
dpath=['save c:\ocean2006\fluxes\\xwniata200' y d 'T200.dat data -ascii'];    % the same as xnata2006 plus water vapor flux
eval(dpath);
%spath=['save c:\ocean\radon\meteo_3d\data\fluxes\\xnflux200' y d 'T200'];
%eval(spath);
%%clear H Fp Fp2 UW UST L Su Sv Sw ST SN MT MU WD MN lagp jjj1 jjj2 time  Mroll  Mpitch Mlat Mlong Malt Mhead Sroll Spitch Shead Slat Slong Salt data]=TOflux(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll);
%dpath=['save c:\ocean\radon\meteo_3d\data\fluxes\\xnata200T' d '.dat data -ascii'];
%eval(dpath);
clear 
global days
global i
end