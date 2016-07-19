load filtereddata3
XV(:,47:50)=zeros(length(XV),4);
day=[111802 100901 92503 90801 82904 20402  80801 80902 81001 81101 81501 90409];% 31401 12701];
for flight=1:length(day),
    d=num2str(day(flight));
    k=find(XV(:,1)==day(flight));
    xv=XV(k,:);
    wed=floor(xv(1,2)/3600/24);
    utc=xv(:,2)-wed*24*3600;
   if length(d)==5, d=['0' d]; end
   m=d(1:2); dd=d(3:4); 
   if str2num(m)==8, y=6; else y=3; end
   if day(flight)==82904, y=3; end
   if day(flight)==20402, y=4; end
   s=['load C:\ocean2006\hrad\aerorad\chl200' num2str(y) '_' m '_' dd '.dat'];
   eval(s)
   s=['datcl=chl200' num2str(y) '_' m '_' dd ';'];
   eval(s)
   s=['clear chl200' num2str(y) '_' m '_' dd ';'];
   eval(s)
   %plot(utc,xv(:,18)*180/pi,'o',datcl(:,1),datcl(:,3),'.')
   %figure
   %plot(utc,xv(:,19)*180/pi,'o',datcl(:,1),datcl(:,2),'.') 
   k100=find(datcl(:,5)>1000);
   datcl(k1000,:)=[];
   length(k1000)
   cl=interp1q(datcl(:,1),datcl(:,5),utc);
   %figure
   %plot(datcl(:,1),datcl(:,5),'.',utc,cl,'.')
   XV(k,47)=cl;
   clear s xv k d m dd y utc cl k1000
   end
   