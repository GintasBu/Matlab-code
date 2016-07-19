% like oceanfluxes.m but adds water vapor flux calculation
%like oceanfluxesw.m but includes speeditup conci and corresponding
%particle flux Fp3 and Fp3b from 10Hz data
global days
global i
days=[ 80201 80303 80402 80504 80701 80902 81501 80801 81001 81101 81201];
%days=[80801 81001 81101 81501 80902 80201];
for i=11,
    d=num2str(days(i));
    if length(d)<6;
        d=['0' d]
    end
    
    dd=d(1:2);
    dd=str2num(dd);
    if dd<5,
        y='4'; else y='3';
    end
    y=6;
        cpath=['load c:\ocean2006\turbulence\\Gcimeteo2006' d '20Hz'];
eval(cpath);

%[H,Fp,Fp2,UW,UST,L,Su,Sv,Sw,ST,SN,MT,MU,WD,MN,lagp,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, Sroll, Spitch, Shead, Slat, Slong, Salt,data]=TOflux(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll);
%[H,Fw,Fp,Fp2,UW,UST,L,Su,Sv,Sw,ST,SN,MT,MU,WD,MN,Mqv, MPstatic,
%lagp,lagv,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, MSST,dT,Sroll, Spitch, Shead, Slat, Slong, Salt,SSST,sdT,Sqv,SPstatic,data,qv]=TOfluxjn2w(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll, SST, r_Irga, Pstatic);
[H,Fw,Fp,Fp2,Fp3, Fp3b, Fpw, Fph, UW,UST,L,Su,Sv,Sw,ST,SN, SNi,MT,MU,WD,MN, Mqv,MPstatic, Mr_Irga, lagp, lagpi,lagv,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, MSST,dT,Sroll, Spitch, Shead, Slat, Slong, Salt,SSST,sdT, Sqv, SPstatic,Sr_Irga, data, qv]=TOfluxjn2wi(GPSTime,GPSTimei,u,v,w, wi,T,conc, conc2,longitude, latitude, altitude, heading, pitch, roll, SST, r_Irga, Pstatic);
spath=['save c:\ocean2006\fluxes\\xwiflux2006' d 'T100.mat -mat'];   % the same as xnflux2006 plus water vapor flux
eval(spath);
dpath=['save c:\ocean2006\fluxes\\xwinata2006' d 'T100.dat data -ascii'];    % the same as xnata2006 plus water vapor flux
eval(dpath);
%clear H Fp Fp2 UW UST L Su Sv Sw ST SN MT MU WD MN lagp jjj1 jjj2 time  Mroll  Mpitch Mlat Mlong Malt Mhead Sroll Spitch Shead Slat Slong Salt data]=TOflux(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll);
clear 
global days
global i
end
