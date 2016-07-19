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
   s=['datcl1=chl200' num2str(y) '_' m '_' dd ';'];
   eval(s)
   s=['clear chl200' num2str(y) '_' m '_' dd ';'];
   eval(s)
   k1000=find(datcl1(:,5)>1000);
   datcl1(k1000,:)=[];
   length(k1000)
   cl=interp1q(datcl1(:,1),datcl1(:,5),utc);
   XV(k,47)=cl;
   clear s cl k1000
   if y<6,
       s=['load C:\ocean2006\hrad\aerorad\chl200' num2str(y) '_' m '_' dd 'A.dat'];
   eval(s)
   s=['datcl2=chl200' num2str(y) '_' m '_' dd 'A;'];
   eval(s)
   s=['clear chl200' num2str(y) '_' m '_' dd 'A;'];
   eval(s)
   k1000=find(datcl2(:,5)>1000);
   datcl2(k1000,:)=[];
   length(k1000)
   cl=interp1q(datcl2(:,1),datcl2(:,5),utc);
   XV(k,48)=cl;
   clear s cl k1000
   else
        s=['load C:\ocean2006\hrad\aerorad\chl200' num2str(y) '_' m '_' dd 'cloud.dat'];
   eval(s)
   s=['datcl2=chl200' num2str(y) '_' m '_' dd 'cloud;'];
   eval(s)
   s=['clear chl200' num2str(y) '_' m '_' dd 'cloud;'];
   eval(s)
   k1000=find(datcl2(:,5)>1000);
   datcl2(k1000,:)=[];
   length(k1000)
   cl=interp1q(datcl2(:,1),datcl2(:,5),utc);
   XV(k,48)=cl;
   clear s cl k1000 
   end
   clear xv k d m dd y utc datcl1 datcl2
   end
   