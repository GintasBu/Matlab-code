day=[111802 100901 92503 90801 82904 20402  80801 80902 81001 81101 81501 90409];% 31401 12701];
load coastline.txt
flight=input('flight #= ');
 d=num2str(day(flight));
if length(d)==5, d=['0' d]; end
   mm=d(1:2); ddd=d(3:4);
   if str2num(mm)==8, y=6; else y=3; end
   if day(flight)==82904, y=3; end
   if day(flight)==20402, y=4; end

  
s=['load C:\ocean2006\fluxes\AOSN\xwiflux200' num2str(y) mm ddd d(5:6) 'T200.mat'];
   eval(s)
   clear s
    wed=floor(time(1)/3600/24);
    utc=time'-wed*24*3600;

   s2=['load C:\ocean2006\hrad\aerorad\chl200' num2str(y) '_' mm '_' ddd '.dat'];
   eval(s2)
   s=['datcl1=chl200' num2str(y) '_' mm '_' ddd ';'];
   eval(s)
   s=['clear chl200' num2str(y) '_' mm '_' ddd ';'];
   eval(s)
   

   k1000=find(datcl1(:,5)>1000);
   datcl1(k1000,:)=[];
   length(k1000)
   cl=interp1q(datcl1(:,1),datcl1(:,5),utc);

   clear s k1000
    %y=str2num(y);
   if y<6,
       s=['load C:\ocean2006\hrad\aerorad\chl200' num2str(y) '_' mm '_'  ddd 'A.dat'];
   eval(s)
   s=['datclc=chl200' num2str(y) '_' mm '_' ddd 'A;'];
   eval(s)
   s=['clear chl200' num2str(y) '_' mm '_' ddd 'A;'];
   eval(s)
   k1000=find(datcl2(:,5)>1000);
   datclc(k1000,:)=[];
   length(k1000)
   cl2=interp1q(datclc(:,1),datclc(:,5),utc);
  
   clear s k1000
   else
        s=['load C:\ocean2006\hrad\aerorad\chl200' num2str(y) '_' mm '_' ddd 'cloud.dat'];
   eval(s)
   s=['datclc=chl200' num2str(y) '_' mm '_' ddd 'cloud;'];
   eval(s)
   s=['clear chl200' num2str(y) '_' mm '_' ddd 'cloud;'];
   eval(s)
   k1000=find(datclc(:,5)>1000);
   datclc(k1000,:)=[];
   length(k1000)
   cl2=interp1q(datclc(:,1),datclc(:,5),utc);
  
   clear s k1000 
   end
  y=num2str(y);
   s=['save C:\ocean2006\fluxes\AOSN\xwiclflux200' y mm ddd d(5:6) 'T200.mat'];
   eval(s)
   
   clear k d mm dd y  % datclc datcl1  ddd utc
   %end
   
   h=find(Malt<50);
   subplot(2,2,1)
   contourPlotJK(day(flight) , 'Longitude', 'Latitude', Fp3b(h)+Fph(h)+Fpw(h), Mlong(h)*180/pi, Mlat(h)*180/pi, 0.045, 0.045, 10, 0, 1,[-10,10,1])
   legend('part flux')
   orient landscape
   hold on 
    plot(coastline(:,1), coastline(:,2))
   hold off
    subplot(2,2,2)
   %figure
   contourPlotJK(day(flight), 'Longitude', 'Latitude', cl(h), Mlong(h)*180/pi, Mlat(h)*180/pi, 0.045, 0.045, 10, 0, 1,[0, 5, 0.5])
   legend('chlorophyl')
    orient landscape
    hold on 
    plot(coastline(:,1), coastline(:,2))
   hold off
   %figure
    subplot(2,2,3)
   contourPlotJK(day(flight), 'Longitude', 'Latitude', cl2(h), Mlong(h)*180/pi, Mlat(h)*180/pi, 0.045, 0.045, 10, 0, 1, [0, 5, 0.5])
   legend('chlorophyl2')
    orient landscape
    hold on 
    plot(coastline(:,1), coastline(:,2))
   hold off
   %figure
    subplot(2,2,4)
   %hh=find(altitude<50);
   contourPlotJK(day(flight), 'Longitude', 'Latitude', MSST(h)-273.16, Mlong(h)*180/pi, Mlat(h)*180/pi, 0.045, 0.045, 10, 0, 1, [floor(min(MSST(h))-273.15), ceil(max(MSST(h))-273.15), 0.5])
   legend('SST')
    orient landscape
    hold on 
    plot(coastline(:,1), coastline(:,2))
   hold off
   