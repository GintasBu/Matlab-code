data=[];
%days=[080402 080502 080602 081003 081101 081304 081501 082003 082106 082203 082501 082904 090409 090501 090801 092503 100901 102801 111802 120501 010502 012701 020402 021701];  %AOSN
days=[80201 80303 80402 80504 80701 80801 80902 81001 81101 81201 81501]; %ASAP
%wd=[3 4 5 6 1 2 ]% weekday of the flight: Sunday=0, Monday=1, Tuesday=2,..., Saturday=6
for i=1:length(days),
    d=num2str(days(i));
    if length(d)<6;
        d=['0' d]
    end
    
    dd=d(1:2);
    dd=str2num(dd);
    if dd<5,
        y='4'; else y='6';
    end
    
        cpath=['load c:\ocean2006\fluxes\\xwnata2006' d '.dat'];
eval(cpath);
maked=['dat=xwnata2006' d ';'];
eval(maked);
cleardat=['clear xwnata2006' d];
eval(cleardat);
[l w]=size(dat);
k=zeros(l, w+2);
wd=str2num(d(3:4));

if wd<6,
    swd=1+wd; % to the nearest past Sunday
else
    if wd<13,
        swd=wd-6;
    else swd=wd-13;
    end
end

k(:,1)=k(:,1)+str2num([d(3:4)]); % puts a day of the month of August 2006 in first column
k(:,2)=k(:,2)+(dat(:,1)-swd*24*3600)/24/3600+wd;  % time in days since August 1, UTC
k(:,3:w+2)=dat;
data=[data' k']';
size(data)
clear d dd eval maked cleardat y dat k l w cpath 

end
save totalflux2006.dat data -ascii
%pause
%[H,Fp,Fp2,UW,UST,L,Su,Sv,Sw,ST,SN,MT,MU,WD,MN,lagp,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, Sroll, Spitch, Shead, Slat, Slong, Salt,data]=TOflux(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll);
%[H,Fp,Fp2,UW,UST,L,Su,Sv,Sw,ST,SN,MT,MU,WD,MN,lagp,jjj1,jjj2,time, Mroll, Mpitch, Mlat, Mlong, Malt, Mhead, MSST,dT,Sroll, Spitch, Shead, Slat, Slong, Salt,SSST,sdT,data]=TOflux(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll, SST);

%spath=['save c:\ocean\radon\meteo_3d\data\fluxes\\xnflux200' y d 'T200'];
%eval(spath);
%clear H Fp Fp2 UW UST L Su Sv Sw ST SN MT MU WD MN lagp jjj1 jjj2 time  Mroll  Mpitch Mlat Mlong Malt Mhead Sroll Spitch Shead Slat Slong Salt data]=TOflux(GPSTime,u,v,w,T,conc,longitude, latitude, altitude, heading, pitch, roll);
%dpath=['save c:\ocean\radon\meteo_3d\data\fluxes\\xnata200T' d '.dat data -ascii'];
%eval(dpath);
clear 
global days
global i
%end