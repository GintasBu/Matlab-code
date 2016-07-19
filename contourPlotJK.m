
function contourPlot(titleText, xAxisText, yAxisText, z, x, y, dx, dy, nc, filter, smooth, zrange, krig)
%
%  contourPlot(titleText:string, xAxisText:string, yAxisText:string,
%              z:real vector, x:real vector, y:real vector, 
%              dx:real scalar, dy:real scalar, nc:integer scalar, 
%              filter:real scalar, smooth:integer scalar, zrange:real vector, krig:integer scalar)
%
%  Creates a contour plot of z values against x and y on a grid with 
%  resolution dx x dy, a number (nc) of contours, filtering or not 
%  (filter>=0) of grid data and a level of contours smoothing (0<=smooth<=4).
%  The zrange vector may contain [min, max, step] for the range of contour values.
%  If krig is nonzero then cokriging interpolation is used instead of griddata().
%  If contours number nc is omitted, the default value is 10.
%  If filter is omitted, the default value is 0.
%  If smooth is omitted, the default value is 0.
%  If zrange is omitted, it is automatic calculated.
%  If krig is omitted, the default value is 0.
%  Input empty optional arguments (nc,..., krig) to set them to default value.
%  Negative smooth value will result in not setting to NaN grid points away from input points.
%

%
%  Written by Ioannis Kalogiros, May 3, 2000. Matlab 5.3
%

x=x(:); y=y(:); z=z(:);

							% check arguments
if(nargin<8|nargin>13|nargout>0)
	wrongArg=1;
else
	wrongArg=0;
   %wrongArg=wrongArg|(~ischar(titleText));
   wrongArg=wrongArg|(~ischar(xAxisText));
   wrongArg=wrongArg|(~ischar(yAxisText));
	wrongArg=wrongArg|(~isfloatvector(z));
	wrongArg=wrongArg|(~isfloatvector(x));
   wrongArg=wrongArg|(prod(size(x))~=prod(size(z)));
	wrongArg=wrongArg|(~isfloatvector(y));
   wrongArg=wrongArg|(prod(size(y))~=prod(size(z)));
	wrongArg=wrongArg|(~isfloat(dx));
   wrongArg=wrongArg|(size(dx)~=[1,1]);
   wrongArg=wrongArg|(dx<=eps);
	wrongArg=wrongArg|(~isfloat(dy));
   wrongArg=wrongArg|(size(dy)~=[1,1]);
   wrongArg=wrongArg|(dy<=eps);
   if(nargin>=9&~isempty(nc))
	   wrongArg=wrongArg|(~isfloat(nc));
      wrongArg=wrongArg|(size(nc)~=[1,1]);
      nc=round(nc);
      wrongArg=wrongArg|(nc<=0);
   else
      nc=10;
   end
   if(nargin>=10&~isempty(filter))
	   wrongArg=wrongArg|(~isfloat(filter));
      wrongArg=wrongArg|(size(filter)~=[1,1]);
      wrongArg=wrongArg|(filter<0);
   else
      filter=0;
   end
   if(nargin>=11&~isempty(smooth))
	   wrongArg=wrongArg|(~isfloat(smooth));
      wrongArg=wrongArg|(size(smooth)~=[1,1]);
      fillNaN=~(smooth<0);
      smooth=abs(smooth);
      smooth=round(smooth);
      wrongArg=wrongArg|(smooth<0);
      if(smooth>4) smooth=4; end
   else  
      fillNaN=1;
      smooth=0;
   end
   if(nargin>=12&~isempty(zrange))
	   wrongArg=wrongArg|(~isfloatvector(zrange));
      wrongArg=wrongArg|(length(zrange)~=3);
   else
      zrange=[];
   end
   if(nargin>=13&~isempty(krig))
	   wrongArg=wrongArg|(~isfloat(krig));
      wrongArg=wrongArg|(size(krig)~=[1,1]);
      krig=round(krig);
   else
      krig=0;
   end
end
if(any(wrongArg))
	disp(' ');
   disp('   contourPlot(titleText:string, xAxisText:string, yAxisText:string,');
   disp('               z:real vector, x:real vector, y:real vector,');
   disp('               dx:real scalar, dy:real scalar, nc:integer scalar,');
   disp('               filter:real scalar, smooth:integer scalar,zrange:real vector,krig:integer scalar)');
	disp(' ');
	return
end

                     % force column vectors
if(size(z,2)>1) z=z'; end
if(size(x,2)>1) x=x'; end
if(size(y,2)>1) y=y'; end

                     % make grid                         
minx=dx*round(min(x)/dx+1E-6); maxx=dx*round(max(x)/dx-1E-6); 
miny=dy*round(min(y)/dy+1E-6); maxy=dy*round(max(y)/dy-1E-6); 

index=find(isnan(z)|isnan(x)|isnan(y));
z(index)=[]; x(index)=[]; y(index)=[];

if(length(z)<3) return; end

if(krig)
   [xGrid,yGrid,zi,szi]=kriginterp(x,y,z,minx,dx,maxx,miny,dy,maxy);
else
                     % scaling to avoid problems in Delaunay triangulation grid
   if(maxx-minx==0|maxy-miny==0) return; end
   dx0=dx; dy0=dy; 
   if(dx0/dy0>5|dy0/dx0>5)
      if((maxy-miny)>(maxx-minx))
         dx=dy*(maxx-minx)/(maxy-miny);
      else
         dy=dy*(maxx-minx)/(maxy-miny);
      end
   end
   mx=minx; sx=dx0/dx;
   x=(x-mx)/sx; minx=(minx-mx)/sx; maxx=(maxx-mx)/sx;
   my=miny; sy=dy0/dy;
   y=(y-my)/sy; miny=(miny-my)/sy; maxy=(maxy-my)/sy;

                     % grid data
   if(minx+dx>maxx) maxx=minx+dx; end
   if(miny+dy>maxy) maxy=miny+dy; end
   [xGrid,yGrid]=meshgrid(minx:dx:maxx+0.5*dx, miny:dy:maxy+0.5*dy);
   zi=griddata(x, y, z, xGrid, yGrid, 'linear',{'QJ'});
   if(any(size(zi)~=size(xGrid))) zi=reshape(zi,size(xGrid)); end

   nt=4; nz=4; 
   if(size(zi,1)>nz&size(zi,2)>nt)
      mind=[1:size(zi,1)]; nind=[1:size(zi,2)];
      nrz=2*round((nz-1)/2); mind=[mind(1:nrz),mind,mind(end-nrz+1:end)];
      nrt=2*round((nt-1)/2); nind=[nind(1:nrt),nind,nind(end-nrt+1:end)];
      zn=colfilt(zi(mind,nind),[nz,nt],'sliding','mean');
      zn=zn(nrz+1:nrz+size(zi,1),nrt+1:nrt+size(zi,2));

      %zn=griddata(x, y, z, xGrid, yGrid, 'nearest',{'QJ'});
   
      if(any(size(zn)~=size(xGrid))) zn=reshape(zn,size(xGrid)); end
      index=isnan(zi); zi(index)=zn(index);
   end
                     % rescale
   x=x*sx+mx; xGrid=xGrid*sx+mx; minx=minx*sx+mx; maxx=maxx*sx+mx;
   y=y*sy+my; yGrid=yGrid*sy+my; miny=miny*sy+my; maxy=maxy*sy+my;
   dx=dx0; dy=dy0;
end

                     % smooth z data                        
if(filter>0)
   [m,n]=size(zi);
   zn=zeros([m,n]+2);
   zn(1,1)=zi(1,1);       zn(m+2,n+2)=zi(m,n); 
   zn(1,n+2)=zi(1,n);     zn(m+2,1)=zi(m,1); 
   zn(1,2:n+1)=zi(1,:);   zn(2:m+1,1)=zi(:,1);
   zn(m+2,2:n+1)=zi(m,:); zn(2:m+1,n+2)=zi(:,n);
   zn(2:m+1,2:n+1)=zi;
   h=fspecial('gaussian',3,filter);
   zn=filter2(h,zn);
   zi=zn(2:m+1,2:n+1);
end

if(fillNaN)          % set to NaN grid points away from input points
m=NaN*ones(size(xGrid));
x0=min(min(xGrid));
y0=min(min(yGrid));
for(nx=-1.5:0.25:1.5)   % neighbour points
   for(ny=-1.5:0.25:1.5)
      xx=(x+nx*dx-x0)/dx;
      yy=(y+ny*dy-y0)/dy;
      if(ny>=0) 
         i=floor(yy-1E-6)+1;
      else
         i=ceil(yy+1E-6)+1;
      end
      if(nx>=0) 
         j=floor(xx-1E-6)+1;
      else
         j=ceil(xx+1E-6)+1;
      end
      i=max(i,1); i=min(i,size(xGrid,1));
      j=max(j,1); j=min(j,size(xGrid,2));
      if(~isempty(i))
         l=sub2ind(size(xGrid),i,j); 
         m(l)=1;
      end
   end
end
zi=zi.*m;  
end 

                     % reduce set to NaN by "shading interp" (prior indices data interpolation including NaNs)
l=find(isnan(zi));
if(~isempty(l))
   [i,j]=ind2sub(size(zi),l);
   l1=i>1; l2=j>1; l3=i>1&j>1; 
   zn=zeros(size(l)); 
   if(any(l1)) 
      k1=sub2ind(size(zi),i(l1)-1,j(l1));
      zz=zi(k1); m=find(l1); l1(m(isnan(zz)))=0; zn(l1)=zi(k1(~isnan(zz))); 
   end
   if(any(l2)) 
      k2=sub2ind(size(zi),i(l2),j(l2)-1);
      zz=zi(k2); m=find(l2); l2(m(isnan(zz)))=0; zn(l2)=zn(l2)+zi(k2(~isnan(zz))); 
   end
   if(any(l3)) 
      k3=sub2ind(size(zi),i(l3)-1,j(l3)-1);
      zz=zi(k3); m=find(l3); l3(m(isnan(zz)))=0; zn(l3)=zn(l3)+zi(k3(~isnan(zz))); 
   end
   n=l1+l2+l3;
   zi(l(n>0))=zn(n>0)./n(n>0);   % check zi change using pcolor(zi) before and after
end

                      % plot pseudocolor map and contours
if(~isempty(zrange))
   minz=zrange(1); maxz=zrange(2); dz=zrange(3);
else
   minz=min(min(zi)); maxz=max(max(zi)); 
   dz=(maxz-minz)/nc; 
   if(dz>0) 
      dz=log10(dz); dz=round(10^(dz-floor(dz)))*10^(floor(dz));
      minz=dz*floor(minz/dz); maxz=dz*ceil(maxz/dz);
   end
end

                     % first correct coordinates offset problem in pcolor (surface) and contour routines
dxG=diff(xGrid'); dxG=median(median(dxG(~isnan(dxG)))); 
dyG=diff(yGrid);  dyG=median(median(dyG(~isnan(dyG))));
if(size(zi,2)>1)
   xGrid=[xGrid,xGrid(:,end)+dxG];
   yGrid=[yGrid,yGrid(:,end)];
   zi=[zi,2*zi(:,end)-zi(:,end-1)];
end
if(size(zi,1)>1)
   xGrid=[xGrid;xGrid(end,:)];
   yGrid=[yGrid;yGrid(end,:)+dyG];
   zi=[zi;2*zi(end,:)-zi(end-1,:)];
end
xGrid=xGrid-0.5*dxG;
yGrid=yGrid-0.5*dyG;

%figure;
warning off;
h=pcolor(xGrid, yGrid, zi);   % comment these lines for not making color fillings !!!!!
shading('interp');            % comment these lines for not making color fillings !!!!!
set(h,'FaceLighting','phong');
if(maxz>minz) 
caxis([minz,maxz]);           % comment these lines for not making color fillings !!!!!
colormap;                     % comment these lines for not making color fillings !!!!!
hold on;
v=[minz:dz:maxz];
if(any(any(~isnan(zi))))
   [C,h]=contour(interp2(xGrid,smooth), interp2(yGrid,smooth), interp2(zi,smooth),v,'k-');
   for(n=1:length(h)) set(h(n),'Tag','contour'); end
   hold off;
   if(~isempty(C)) 
      h=clabel(C,h); 
      for(n=1:length(h)) set(h(n),'Tag','clabel'); end
   end
end
end


                      % texts
title(titleText,'fontsize',12,'tag','title'); 
xlabel(xAxisText,'fontsize',12,'tag','xlabel'); 
ylabel(yAxisText,'fontsize',12,'tag','ylabel'); 
set(gca, 'TickDir', 'out');

                      % color bar
h=colorbar('v6','vert');
sa=get(gca,'Position'); s=get(h,'Position');
set(h,'Position',[sa(1)+sa(3)+0.5*s(3) s(2) 0.5*s(3) s(4)]);
set(h,'Tag','colorbar');

                      % points used 
%hold on; plot(x,y,'w+','markersize',4); hold off;


return

