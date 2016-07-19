function [ff, pp]=averspecplotp(P,N, Fs)
% reduces number of poin,s for the specplot function
% P output of spectrum.m
% N number of points for succesful plot
% Fs measurement frequency

[n,m] = size(P);
pp=zeros(N,m);
if nargin < 3
   Fs = 1;
end
f = (1:n)/n*Fs/2;
F=zeros(N,1);
F(1)=min(f);
F(N+1)=max(f);
dlN=(log10(F(N+1)/F(1)))/N;
for i=2:N,
   F(i)=10^(log10(F(i-1))+dlN);
end
for j=1:N
  ff(j)=F(j+1)/2+F(j)/2;
  k=find(f<F(j+1) & f>F(j));
   for g=1:m
      pp(j,g)=mean(P(k,g));
   end
end

      