function r=xcorr(x,y,lagf,lagl)
% cross correlation of x and y for lags lagf ... lagl

BD = -9999;

N=length(x);

% Linear trend removal-removed

stx=std(x(x~=BD));
sty=std(y(y~=BD));

r=zeros(lagl-lagf+1,1);
for i=lagf:lagl
    if i<0
     x1=x(1-i:N);
     x2=y(1:N+i);
    else
     x1=x(1:N-i);
     x2=y(1+i:N);
    end
    j=find(x1~=BD & x2~=BD);
    r(i-lagf+1)=sum(x1(j).*x2(j))/length(j);
end

r=r/(stx*sty);

r=[(lagf:lagl)' r];
