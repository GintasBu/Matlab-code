% load the data from Z file containing: counter-ana-CMIG data, CPC - is serial data, z - 10Hz data
display('get counter file')
[file, dir]=uigetfile('*.ss');
sz=['load ' dir file];
r=input('choose a date, from 72603 80102 80201 80303 80402 80504 80701 80801 80902 81001 81101 81201 81404 81501:    ','s');
scpc=['load c:\ocean2006\cabinfiles\\CABIN_060' r '.txt'];
eval(scpc);
eval(sz);
sz0=['X' file(1:length(file)-3)];
scpc0=['CABIN_060' r];
l2cpc=sprintf('cpc=%s;', scpc0);
eval(l2cpc);
l2z=sprintf('z=%s;', sz0);
eval(l2z);
l3cpc=sprintf('clear %s;', scpc0);
eval(l3cpc);
l3z=sprintf('clear %s;', sz0);
eval(l3z);

k=find(cpc==-9999);
cpc(k)=NaN;

clear scpc sz lcp lz l2cpc l2z l3cpc l3z
%  ****************data was downloaded

% plot concentrations
%counts=z(:,2)*10/2.35/16.6667; 
counts=z(:,4)*10/2.35/16.6667; % as of 120501

timecounts=z(:,2);

c3010=cpc(:,30)*0.95; % 0.95 is a fake constant to match concentrations
timec3010=cpc(:,1);

cflux=cpc(:,28)/2.35;

semilogy(timecounts,counts,'b.-',timec3010,c3010,'g.-',timec3010,cflux,'.r')
title('flux:blue(counter)& red(serial), green-3010 ')
ylabel('aerosol number concentration')
xlabel(['mission time on 060' r '  flight'])
axis([0 12000 300 40000])
orient landscape
grid
pause
ppp=['print -djpeg f060' r]
eval(ppp)

clear all
close all

