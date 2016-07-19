
function itis=isfloatvector(input)
%
%	itis:logical=isfloatvector(input)
%
%	Returns 1 (true) if input is a not empty 
%	numeric real vector, else 0 (false)
%

%
%  Written by Ioannis Kalogiros, May 3, 2000. Matlab 5.3
%

itis=1;
[m,n]=size(input);
itis=itis&(~(m>1&n>1));
itis=itis&isnumeric(input)&isreal(input);

return
