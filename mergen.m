function newfile=mergen(flightNo),

display('get counter file')
[filename, filepath]=uigetfile('*.ss');
s2=[sprintf('load ') filepath sprintf('\') filename];
eval(s2);
s4=['part=X' filename(1:length(filename)-3) ';' ];
eval(s4);

clear s2, s4

display('get cmig file')
[filename2, filepath2]=uigetfile('*.ss');
s2=[sprintf('load ') filepath2 sprintf('\') filename2];
eval(s2);
s3=['cmig=' filename2(1:length(filename2)-3) ';'];
eval(s3)

s5=['clear X' filename(1:length(filename)-3) ];
eval(s5)
s6=['clear ' filename2(1:length(filename2)-3) ];
eval(s6)

clear s2 s3 s4 s5 s6 filename filepath filename2 filepath2

j=find(part(:,1)==1);
j=[j'+1 j'+2 j'+3]';
part2=part;
part2(j,:)=[];

conc55=part2(:,4)*10/2.35/16.667;  % before 0822
tconc55=part2(:,2); % before 0822
%tconc55=part2(:,2);

conccm=interp1q(tconc55,conc55,cmig(:,1));
%plot(tconc55,conc55,'.-', cmig(:,1),conccm, 'o-')
%pause
display('get turb file')
[filename3, filepath3]=uigetfile('*.mat');
s2=[sprintf('load ') filepath3 sprintf('\') filename3];
eval(s2);


conc=interp1q(cmig(:,2),conccm,GPSTime);
plot(GPSTime, conc,'.-',cmig(:,2),conccm,'.-')
pause
s7=(['save ' filepath3 'Gc' filename3]);   % Gc contains c-migit data
heading=interp1q(cmig(:,2),cmig(:,11),GPSTime);
pitch=interp1q(cmig(:,2),cmig(:,9),GPSTime);
roll=interp1q(cmig(:,2),cmig(:,10),GPSTime);
clear s2 filename3 filepath3 conccm part2 part j s5 s6 s4 s3 cpath conc55 tconc55

Rv=461.51;
e=Pstatic.*r_Irga./(1000*0.622+r_Irga);
rhov=1000*e./(Rv.*T/100);
offset=[-0.23,0.63,0.82,0.53,-0.24,-0.24,0.02,0,0.71,4.02,0.33];
rhov=polyval([2.57,1.63],rhov-5)+offset(flightNo); 
e=(rhov/1000).*Rv.*T/100;
r_Irgaraw=r_Irga;
r_Irga=1000*0.622*e./(Pstatic-e);

%plot(GPSTime, r_Irgaraw, GPSTime, r_Irga)
legend('raw' ,'corrected')

thetav=T.*(1+0.608*(r_Irga*0.001./(r_Irga*0.001+1))).*((1013./Pstatic).^0.286);
figure
%plot(GPSTime, T, GPSTime, thetav,'g')
legend('T','thetav')
clear Rv e rhov offset 



eval(s7)
clear all
close all