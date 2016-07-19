load xv.dat
load coastline.txt
load latlongaug2.mat
ku=find(xv(:,6)>0.1);
lat=xv(ku,19)*180/pi;
long=xv(ku,18)*180/pi;
flux=xv(ku,4)+xv(ku,41)+xv(ku,42);
contourPlotJK('Flux #/(cm^2 s)','long','lat',flux*100, long, lat, 0.05,0.05,10,0,3,[-280,160,160])
hold on, plot(long2,lat2,'.k'), hold off
hold on, plot(coastline(:,1),coastline(:,2)), hold off
figure
plot3(long,lat,zeros(length(long),1),'.',long,lat,flux*100,'.')
grid
