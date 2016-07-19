function [j1, j2]=checkMBL(day, l1, l2),
s2=['load c:\ocean2006\turbulence2003\0' num2str(day) '\\Gnmeteo20030' num2str(day) sprintf('10Hz.mat')];
eval(s2);

j1=find(abs(GPSTime-GPSTime(1)-l1)==min(abs(GPSTime-GPSTime(1)-l1)));
j2=find(abs(GPSTime-GPSTime(1)-l2)==min(abs(GPSTime-GPSTime(1)-l2)));
plot(thetav(j1:j2),altitude(j1:j2))