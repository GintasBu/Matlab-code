function y=detr2(x,y)
% 

% Linear trend removed
p = polyfit(x,y(x),1);
y(x) = y(x)-(p(2)+p(1)*x);
