% VS2, plots chlor against its own lat long

day=[111802 100901 92503 90801 82904 20402  80801 80902 81001 81101 81501 90409 90501 102801 31401 12701 21701];
load coastline.txt
flight=input('flight #= ');
 d=num2str(day(flight));
if length(d)==5, d=['0' d]; end
   mm=d(1:2); ddd=d(3:4);
   if str2num(mm)==8, y=6; else y=3; end
   if day(flight)==82904, y=3; end
   if day(flight)==20402 || day(flight)==12701, y=4; end
   if day(flight)==21701, y=4; end
  
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
   length(k1000);
   cl=interp1q(datcl1(:,1),datcl1(:,5),utc);

   clear s k1000
    y=str2num(y);
   if y<6,
       s=['load C:\ocean2006\hrad\aerorad\chl200' num2str(y) '_' mm '_'  ddd 'A.dat'];
   eval(s)
   s=['datclc=chl200' num2str(y) '_' mm '_' ddd 'A;'];
   eval(s)
   s=['clear chl200' num2str(y) '_' mm '_' ddd 'A;'];
   eval(s)
   k1000=find(datclc(:,5)>1000);
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
   
   h=find(Malt<50); h2=find(Malt<50 & Fp3b/2.37>-1 & Fp3b/2.37<1);
   subplot(2,2,1)
   %contourPlotJK(day(flight) , 'Longitude', 'Latitude', Fp3b(h)+Fph(h)+Fpw(h), Mlong(h)*180/pi, Mlat(h)*180/pi, 0.045, 0.045, 10, 1, 1,[-10,10,1])
   %legend('part flux')
   plotwd(longitude, latitude, Mlat, Mlong, altitude, Malt, WD, u, v, w, MU, day, flight, SST);
   orient landscape
   hold on 
    plot(coastline(:,1), coastline(:,2),'k')
   hold off
   grid
    subplot(2,2,2)
   %figure
   contourPlotJK(day(flight), 'Longitude', 'Latitude', datclc(:,5), datclc(:,3), datclc(:,2), 0.045, 0.045, 10, 1, 1)
   legend('chlorophyl2')
    orient landscape
    hold on 
    plot(coastline(:,1), coastline(:,2),'k')
   hold off
   grid
   
   %figure
    subplot(2,2,3)
       if day(flight)==92503 ,
        contourPlotJK('part flux, filtered' , 'Longitude', 'Latitude', (Fp3b(h2)+Fph(h2)+Fpw(h2))/2.38, Mlong(h2)*180/pi, Mlat(h2)*180/pi, 0.045, 0.045, 10, 1, 1,[-1,1,0.25])
       else if day(flight)==90409,
                contourPlotJK('part flux, filtered' , 'Longitude', 'Latitude', (Fp3b(h2)+Fph(h2)+Fpw(h2))/2.38, Mlong(h2)*180/pi, Mlat(h2)*180/pi, 0.045, 0.045,10,0,0,[-2,2,0.5])
           else
          contourPlotJK('part flux, filtered' , 'Longitude', 'Latitude', (Fp3b(h2)+Fph(h2)+Fpw(h2))/2.38, Mlong(h2)*180/pi, Mlat(h2)*180/pi, 0.045, 0.045, 10, 1, 1,[-1,1,0.25])
           end
       end
      
       
       
     orient landscape
      grid
    hold on 
    plot(coastline(:,1), coastline(:,2),'k')
   hold off
   %figure
    subplot(2,2,4)
   h3=find(altitude<50 & SST<291);
   contourPlotJK('SST', 'Longitude', 'Latitude', SST(h3)-273.16, longitude(h3)*180/pi, latitude(h3)*180/pi, 0.045, 0.045, 10, 1, 1, [floor(min(SST(h3))-273.15), min(ceil(max(SST(h3))-273.15), 18), 0.5])
   
    orient landscape
    hold on 
    plot(coastline(:,1), coastline(:,2),'k')
    grid
   hold off
   
   %%%%%%%%%%%%% from here second figure!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
   
   figure
  
   subplot(2,2,1)
  contourPlotJK(day(flight), 'Longitude', 'Latitude', datcl1(:,5), datcl1(:,3), datcl1(:,2), 0.045, 0.045, 10, 1, 1)
   legend('chlorophyl')
    orient landscape
   hold on 
   grid
    plot(coastline(:,1), coastline(:,2),'k')
   hold off
   subplot(2,2,2)
   if day(flight)==90409 ,
        contourPlotJK('full part flux' , 'Longitude', 'Latitude', (Fp3b(h)+Fph(h)+Fpw(h))/2.38, Mlong(h)*180/pi, Mlat(h)*180/pi, 0.045, 0.045)
       else
        contourPlotJK('full part flux' , 'Longitude', 'Latitude', (Fp3b(h)+Fph(h)+Fpw(h))/2.38, Mlong(h)*180/pi, Mlat(h)*180/pi, 0.045, 0.045, 10, 1, 1,[-10,10,1])
   end
  grid
   orient landscape
   hold on 
    plot(coastline(:,1), coastline(:,2),'k')
   hold off
   subplot(2,2,3)
   contourPlotJK('aerosol number' , 'Longitude', 'Latitude', conc(h3)/2.38, longitude(h3)*180/pi, latitude(h3)*180/pi, 0.045, 0.045, 10, 1, 1)
   orient landscape
   hold on 
    plot(coastline(:,1), coastline(:,2),'k')
   hold off
   
   grid
  subplot(2,2,4)
   plot3(longitude(h3)*180/pi,latitude(h3)*180/pi, conc(h3)/2.38,'.')
grid
axis([-122.8 -121.8, 36.3 37.3 0 10000])

%figure
%subplot(3,1,1)
 %  plotwd(longitude, latitude, Mlat, Mlong, altitude, Malt, WD, u, v, w, MU, day, flight, SST);
  % orient landscape
  % hold on 
  %  plot(coastline(:,1), coastline(:,2),'k')
  % hold off
  % grid
  % title('Wind, m/s')
   
  % subplot(3,1,2)
  % h3=find(altitude<50 & SST<291);
  % contourPlotJK('SST', '', 'Latitude', SST(h3)-273.16, longitude(h3)*180/pi, latitude(h3)*180/pi, 0.045, 0.045, 10, 0, 0, [floor(min(SST(h3))-273.15), min(ceil(max(SST(h3))-273.15), 18), 0.5])
  % title('SST, C')
   % orient landscape
  %  hold on 
   % plot(coastline(:,1), coastline(:,2),'k')
   % grid
 %  hold off
   
  % subplot(3,1,3)
  % contourPlotJK(day(flight), 'Longitude', 'Latitude', datclc(:,5), datclc(:,3), datclc(:,2), 0.045, 0.045, 10, 1, 1)
  % title('chlorophyl2')
  %  orient landscape
  %  hold on 
 %   plot(coastline(:,1), coastline(:,2),'k')
  % hold off
  % grid
   h33=find(Malt<60 & MSST<294);
   figure
   contourPlotJK(day(flight) , 'Longitude', 'Latitude', H(h33), Mlong(h33)*180/pi, Mlat(h33)*180/pi, 0.045, 0.045, 10, 1, 1)
   legend('Heat flux, W m^-^2')
  grid
   ppp=['print -djpeg c:/ocean2003/figures//heatflux2003' num2str(days(i))];
  % eval(ppp)
   
   figure
      plot3(longitude(h3)*180/pi,latitude(h3)*180/pi, conc(h3)/2.37,'.')
      grid
      figure
      FFpp=(Fp3b+Fph+Fpw);
      plot3(Mlong(h)*180/pi,Mlat(h)*180/pi, FFpp(h)/2.37,'.',Mlong*180/pi,Mlat*180/pi, zeros(1,length(FFpp)))
      grid
   %Q=T;
      Q=thetav(r_Irga, T, Pstatic);
figure
plot(altitude)
a=ginput(8);
a(:,2)=[];
plot3(longitude(a(1):a(2))*180/pi,latitude(a(1):a(2))*180/pi, altitude(a(1):a(2)),longitude(a(2):a(3))*180/pi,latitude(a(2):a(3))*180/pi, altitude(a(2):a(3)), longitude(a(3):a(4))*180/pi,latitude(a(3):a(4))*180/pi, altitude(a(3):a(4)),longitude(a(4):a(5))*180/pi,latitude(a(4):a(5))*180/pi, altitude(a(4):a(5)),longitude(a(5):a(6))*180/pi,latitude(a(5):a(6))*180/pi, altitude(a(5):a(6)),longitude(a(6):a(7))*180/pi,latitude(a(6):a(7))*180/pi, altitude(a(6):a(7)),longitude(a(7):a(8))*180/pi,latitude(a(7):a(8))*180/pi, altitude(a(7):a(8)))
grid
figure
plot(Q(a(1):a(2)), altitude(a(1):a(2)),Q(a(2):a(3)), altitude(a(2):a(3)),Q(a(3):a(4)), altitude(a(3):a(4)), Q(a(4):a(5)), altitude(a(4):a(5)),Q(a(5):a(6)), altitude(a(5):a(6)),Q(a(6):a(7)), altitude(a(6):a(7)),Q(a(7):a(8)), altitude(a(7):a(8)))
figure
Q=conc/2.37;
semilogx(Q(a(1):a(2)), altitude(a(1):a(2)),Q(a(2):a(3)), altitude(a(2):a(3)),Q(a(3):a(4)), altitude(a(3):a(4)), Q(a(4):a(5)), altitude(a(4):a(5)),Q(a(5):a(6)), altitude(a(5):a(6)),Q(a(6):a(7)), altitude(a(6):a(7)),Q(a(7):a(8)), altitude(a(7):a(8)))

   