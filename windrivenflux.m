function [Fm, Fml]=windriven(U),
x=0.16*U-1.49;
Fm=10.^x;
xl=0.13*U-2.09;
Fml=10.^xl;