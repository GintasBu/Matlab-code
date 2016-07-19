% make wind plot
function wind=plotwd(longitude, latitude, Mlat, Mlong, altitude, Malt, WD, u, v, w, MU, day, flight, SST);
wind=sqrt(u.*u+v.*v+w.*w);
h=find(altitude<50 & SST < 291); h2=find(Malt<50);

if day(flight)==92503 || day(flight)==82904 || day(flight)==90501 || day(flight)==90409 || day(flight)==21701,
  contourPlotJK('mean wind speeds', 'Longitude', 'Latitude', MU(h2), Mlong(h2)*180/pi, Mlat(h2)*180/pi, 0.045, 0.045); 
else
  contourPlotJK('winds', 'Longitude', 'Latitude', wind(h), longitude(h)*180/pi, latitude(h)*180/pi, 0.035, 0.035);  
end

v2=MU(h2).*cos(WD(h2)/180*pi);
u2=MU(h2).*sin(WD(h2)/180*pi);
[longi lati]=meshgrid(min(longitude*180/pi):0.04:max(longitude*180/pi),min(latitude*180/pi):0.04:max(latitude*180/pi));
u2b=griddata(Mlong(h2)*180/pi, Mlat(h2)*180/pi,u2,longi, lati);
v2b=griddata(Mlong(h2)*180/pi, Mlat(h2)*180/pi,v2,longi, lati);
hold on
quiver(longi(1,:),lati(:,1),-u2b,-v2b,'k');
hold off