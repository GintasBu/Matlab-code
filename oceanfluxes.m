global days
global i
days=[80201 80303 80402 80504 80701 80801 80902 81001 81101 81201 81404 81501];
for i=8:8,
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
        cpath=['load c:\ocean2006\turbulence\\Gmeteo2006' d '20Hz'];
eval(cpath);

%[H,Fp,Fp2,UW,UST,L,Su,Sv,Sw,ST,SN,MT,MU,WD,MN,lagp,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, Sroll, Spitch, Shead, Slat, Slong, Salt,data]=TOflux(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll);
[H,Fp,Fp2,UW,UST,L,Su,Sv,Sw,ST,SN,MT,MU,WD,MN,lagp,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, MSST,dT,Sroll, Spitch, Shead, Slat, Slong, Salt,SSST,sdT,data]=TOfluxjn2(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll, SST);

spath=['save c:\ocean2006\fluxes\\xnflux2006' d 'T200 -mat'];
eval(spath);
dpath=['save c:\ocean2006\fluxes\\xnata2006' d '.dat data -ascii'];
eval(dpath);
%clear H Fp Fp2 UW UST L Su Sv Sw ST SN MT MU WD MN lagp jjj1 jjj2 time  Mroll  Mpitch Mlat Mlong Malt Mhead Sroll Spitch Shead Slat Slong Salt data]=TOflux(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll);
clear 
global days
global i
end