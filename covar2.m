function c=covar2(x,y,lag)
% Covariance of x and y
BD = -9999; 

N=length(x);

%if dt
% Mean removed
%n=mean(x);
%m=mean(y);
%x=x-n;
%y=y-m;

% Linear trend removed
%t=(1:N);
%p=polyfit(t,x,1);
%x=x-(p(2)+p(1)*t);
%p=polyfit(t,y,1);
%y=y-(p(2)+p(1)*t);

%x=detrend(x);
%y=detrend(y);
%end


if lag
x = x(1:N-lag);
y = y(1+lag:N);
end
size(x);
size(y);
%j=find(x~=BD & y~=BD);
%c=sum(x(j).*y(j))/length(j);
c=sum(x(:).*y(:))/length(x);

