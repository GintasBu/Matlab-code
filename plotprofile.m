global days
global i
global xv
xv=[]; 
%load xv.dat
days=[80201 80303 80402 80504 80701 80801 80902 81001 81101 81201 81404 81501];

for i=2:2,
    d=num2str(days(i));
    if length(d)<6;
        d=['0' d]
    end
    
    dd=d(1:2);
    dd=str2num(dd);
    if dd<5,
        y='4'; else y='3';
    end
    
        cpath=['load c:\ocean2006\cabinfiles\\CABIN_06' d '.txt'];
eval(cpath);

scpc0=['CABIN_06' d];
l2cpc=sprintf('data=%s;', scpc0);
eval(l2cpc);
 clear scpc0 l2cpc cpath
 cpath=['load c:\ocean2006\pafiles\\pa' d 's'];
 eval(cpath)

j=find(data==-9999);
data2=data;
data2(j)=NaN;
tt=data2(:,1);
[lll www]=size(data2);
if www==32, alt=data2(:,32); else alt=data2(:,16); end % takes ralt data from column 32 when available
subplot(2,2,1)
plot(tt,data2(:, 16), tt,alt)
subplot(2,2,3)

plot3(-data2(:,4),data2(:,3),alt)

for z=1:length(amin)
    l1=amin(z); l2=amax(z);

j1=find(abs(tt-l1)==min(abs(tt-l1)));
j2=find(abs(tt-l2)==min(abs(tt-l2)));

subplot(2,2,1)
hold on

if z==1,
    plot( tt(j1:j2),alt(j1:j2),'.b')
else if z==2,
         plot( tt(j1:j2),alt(j1:j2),'.g')
    else if z==3,
             plot( tt(j1:j2),alt(j1:j2),'.c')
        else if z==4,
                 plot( tt(j1:j2),alt(j1:j2),'.k')
            else if z==5
                     plot( tt(j1:j2),alt(j1:j2),'.r')
                else  plot( tt(j1:j2),alt(j1:j2),'.m')
                end
            end
        end
    end
end
          

hold off
%legend('cm','pr','p1', 'p2','p3','p4','p5')
xlabel('Missiontime,s')
grid
ylabel('Altitude, m')
title([num2str(d) ': ' num2str(l1) '  ' num2str(l2)])

subplot(2,2,3)
hold on
if z==1,
    plot3(-data2(j1:j2,4),data2(j1:j2,3),alt(j1:j2),'.')
else if z==2,
         plot3(-data2(j1:j2,4),data2(j1:j2,3),alt(j1:j2),'.g')
    else if z==3,
             plot3(-data2(j1:j2,4),data2(j1:j2,3),alt(j1:j2),'.c')
        else if z==4,
                 plot3(-data2(j1:j2,4),data2(j1:j2,3),alt(j1:j2),'.k')
            else if z==5
                     plot3(-data2(j1:j2,4),data2(j1:j2,3),alt(j1:j2),'.r')
                else  plot3(-data2(j1:j2,4),data2(j1:j2,3),alt(j1:j2),'.m')
                end
            end
        end
    end
end
%plot3(-data2(j1:j2,4),data2(j1:j2,3),data2(j1:j2,16),'.')
grid
%legend('all','p1', 'p2','p3','p4','p5')
hold off
xlabel('^oLongitude')
ylabel('^oLatitude')
zlabel('altitude, m')
zmax=max(data2(:,16));
axis([-122.8 -121.8 36.6 37.3 0 zmax])
subplot(2,2,2)
%legend('p1', 'p2','p3','p4','p5')
hold on
if z==1,
    plot(data2(j1:j2,13),alt(j1:j2),'.' )
else if z==2,
         plot(data2(j1:j2,13),alt(j1:j2),'.g' )
    else if z==3,
             plot(data2(j1:j2,13),alt(j1:j2),'.c' )
        else if z==4,
                plot(data2(j1:j2,13),alt(j1:j2),'.k' )
            else if z==5
                     plot(data2(j1:j2,13),alt(j1:j2),'.r' )
                else  plot(data2(j1:j2,13),alt(j1:j2),'.m' )
                end
            end
        end
    end
end
%plot(data2(j1:j2,13),data2(j1:j2,16),'.' )
ylabel('Altitude, m')
xlabel('Tdamb, C')
%title('blue-conc, red-windspeed*1000')
grid
%legend('p1', 'p2','p3','p4','p5')
hold off
subplot(2,2,4)
hold on
if z==1,
    plot(data2(j1:j2,12),alt(j1:j2),'.' )
else if z==2,
         plot(data2(j1:j2,12),alt(j1:j2),'.g' )
    else if z==3,
             plot(data2(j1:j2,12),alt(j1:j2),'.c' )
        else if z==4,
                plot(data2(j1:j2,12),alt(j1:j2),'.k' )
            else if z==5
                     plot(data2(j1:j2,12),alt(j1:j2),'.r' )
                else  plot(data2(j1:j2,12),alt(j1:j2),'.m' )
                end
            end
        end
    end
end
%plot(data2(j1:j2,12),data2(j1:j2,16),'.' )
ylabel('Altitude, m')
hold off
%legend('p1', 'p2','p3','p4','p5')
xlabel('Tamb, C')
%title('red-SST, blue-T')
grid

%pause
end
subplot(2,2,1)

aamin=min(amin);
aamax=max(amax);
axis([aamin aamax -50 zmax])


%plot(time,Fp,data2(:,1),data2(:,2),'.r')
%[f g]=size(data2);
%data3=zeros(f,1)+str2num(d);

%data3(:,2:g+1)=data2;
%xv=[xv' data3']';
%pause
clear 
global days
global i
global xv
figure
end
%save xv.dat xv -ascii