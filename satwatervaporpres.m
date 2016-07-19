function ps=satwatervaporpres(T),

%ps=6.11*exp(19.83-5417/T); % T  in kelvins, ps in mbar
 ps=610.78*exp((T-273.15)./((T-273.15)+238.3)*17.2694);   % ps in pascals