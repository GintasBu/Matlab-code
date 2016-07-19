function [P9] = spectrum(x,y,m,noverlap)
%SPECTRUM  Power spectrum estimate of one or two data sequences.
%	P = SPECTRUM(X,Y,M) performs FFT analysis of the two sequences
%	X and Y using the Welch method of power spectrum estimation. 
%	The X and Y sequences of N points are divided into K sections of
%	M points each (M must be a power of two). Using an M-point FFT,
%	successive sections are Hanning windowed, FFT'd and accumulated.
%	SPECTRUM returns the M/2 by 8 array
%	   P = [Pxx Pyy Pxy Txy Cxy Pxxc Pyyc Pxyc]
%	where
%	   Pxx  = X-vector power spectral density
%	   Pyy  = Y-vector power spectral density
%	   Pxy  = Cross spectral density
%	   Txy  = Complex transfer function from X to Y
%	         (Use ABS and ANGLE for magnitude and phase)
%	   Cxy  = Coherence function between X and Y
%	   Pxxc,Pyyc,Pxyc = Confidence range (95 percent).
%
%	See SPECPLOT to plot these results.
%	P = SPECTRUM(X,Y,M,NOVERLAP) specifies that the M-point sections
%	should overlap NOVERLAP points.
%	Pxx = SPECTRUM(X,M) and SPECTRUM(X,M,NOVERLAP) return the single
%	sequence power spectrum and confidence range.

%	J.N. Little 7-9-86
%	Revised 4-25-88 CRD, 12-20-88 LS.
%	Copyright (c) 1986-88 by the MathWorks, Inc.

%	The units on the power spectra Pxx and Pyy are such that, using
%	Parseval's theorem,  SUM(X.^2)/M = SUM(Pxx).   The RMS value of the
%	signal is the square root of this.  For example, a pure sine wave with
%	amplitude A has an RMS value of A/sqrt(2), so A = SQRT(SUM(Pxx)*2).

%	See Page 556, A.V. Oppenheim and R.W. Schafer, Digital Signal
%	Processing, Prentice-Hall, 1975.

%if (nargin == 2), m = y; noverlap = 0; end
%if (nargin == 3)
%	if (max(size(y)) == 1)
%		noverlap = m;
%		m = y;
%		nargin = 2;
%	else
%		noverlap = 0;
%	end
%end

x = x(:);		% Make sure x and y are column vectors
y = y(:);
n = max(size(x));	% Number of data points
k = fix((n-noverlap)/(m-noverlap));	% Number of windows
					% (k = fix(n/m) for noverlap=0)
index = 1:m;
w = hamming4(m);
%w = hanning(m);	% Window specification; change this if you want:
			% (Try HAMMING, BLACKMAN, BARTLETT, or your own)

KMU = k*m/2;	% Original KMU = k*m*norm(w)^2/2,  Normalizing scale factor

                % * m removed, SUM(X.^2) = SUM(Pxx),
                % * norm(w)^2 replaced by * m, since normalisation is done
                % by the variance of windowed series, thus *m remains

if (nargin == 2)	% Single sequence case.
	Pxx = zeros(m,1); 
%% Pxx2 = zeros(m,1);
	for i=1:k
		xw = w.*detrend(x(index));
      xw = xw - mean(xw); % added by Yllar
		index = index + (m - noverlap);
		Xx = abs(fft(xw)).^2/std(xw)^2; % changed by Yllar
		Pxx = Pxx + Xx;
%%		Pxx2 = Pxx2 + abs(Xx).^2;
	end
	% Select first half and let 1st point (DC value) be replaced
	% with 2nd point
	select = [2 2:m/2];
	Pxx = Pxx(select);
%%	Pxx2 = Pxx2(select);
%%	cPxx = zeros(m/2,1);
%%	if k > 1
%%		c = (k.*Pxx2-abs(Pxx).^2)./(k-1);
%%		c = max(c,zeros(m/2,1));
%%		cPxx = sqrt(c);
%%	end
%%	pp = 0.95; % 95 percent confidence.
%%	f = sqrt(2)*erfinv(pp);  % Equal-tails.
%%	P = [Pxx f.*cPxx]/KMU;
       	P = [Pxx]/KMU;                  
	return
end

Pxx = zeros(m,1); % Dual sequence case.
Pyy = Pxx; Pxy = Pxx;
%% Pxx2 = Pxx; Pyy2 = Pxx; Pxy2 = Pxx;

for i=1:k
	xw = w.*detrend(x(index));
   xw = xw - mean(xw); % added by Yllar
	yw = w.*detrend(y(index));
   yw = yw - mean(yw); % added by Yllar
	index = index + (m - noverlap);
        
   xw=xw/std(xw); % added by Yllar
   yw=yw/std(yw); % added by Yllar
   cxy=cov(xw,yw);        

	Xx = fft(xw);
	Yy = fft(yw);
	Yy2 = abs(Yy).^2;
	Xx2 = abs(Xx).^2; 
	Xy  = Yy .* conj(Xx)/abs(cxy(2)); % added by Yllar
	Pxx = Pxx + Xx2;
	Pyy = Pyy + Yy2;
	Pxy = Pxy + Xy;
%%	Pxx2 = Pxx2 + abs(Xx2).^2;
%%	Pyy2 = Pyy2 + abs(Yy2).^2;
%%	Pxy2 = Pxy2 + Xy .* conj(Xy);
end

% Select first half and let 1st point (DC value) be replaced with 2nd point
select = [2 2:m/2];

Pxx = Pxx(select);
Pyy = Pyy(select);
Pxy = Pxy(select);
%%Pxx2 = Pxx2(select);
%%Pyy2 = Pyy2(select);
%%Pxy2 = Pxy2(select);

%%cPxx = zeros(m/2,1);
%%cPyy = cPxx;
%%cPxy = cPxx;
%%if k > 1
%%   c = max((k.*Pxx2-abs(Pxx).^2)./(k-1),zeros(m/2,1));
%%   cPxx = sqrt(c);
%%   c = max((k.*Pyy2-abs(Pyy).^2)./(k-1),zeros(m/2,1));
%%   cPyy = sqrt(c);
%%   c = max((k.*Pxy2-abs(Pxy).^2)./(k-1),zeros(m/2,1));
%%   cPxy = sqrt(c);
%%end

%%Txy = Pxy./Pxx; % Complex transfer function
%%Cxy = (abs(Pxy).^2)./(Pxx.*Pyy); % Coherence function

%%pp = 0.95; % 95 percent confidence.
%%f = sqrt(2)*erfinv(pp);  % Equal-tails.

%%P = [ [Pxx Pyy Pxy]./KMU ... 
%%      Txy Cxy ...
%%      f.*[cPxx cPyy cPxy]./KMU ];


if nargout == 1,   % do plots
   Fs=20;
   freq_vector = (select - 1)'*Fs/m;
   %Txy = Pxy./Pxx; % Complex transfer function
   Cxy = (abs(Pxy).^2)./(Pxx.*Pyy); % Coherence function
   
   %newplot;
   [ffx, ffPx]=averspecplotp(freq_vector.*Pxx, 70, Fs);
	%loglog(freq_vector,freq_vector.*Pxx,ffx,ffPx,'*r')
	%title('Pxx - X Power Spectral Density')
	%xlabel('Frequency')
   %pause
 
   %newplot;
   [ffy, ffPy]=averspecplotp(freq_vector.*Pyy, 70, Fs);
   %loglog(freq_vector,freq_vector.*Pyy,ffy,ffPy,'*r')
	%title('Pyy - Y Power Spectral Density')
	%xlabel('Frequency')
	%pause

	%figure;
   fCo=freq_vector.*real(Pxy);
   [ffxy, ffPxy]=averspecplotp(freq_vector.*Pxy, 70, Fs);
   j=find(fCo>=0);
   k=find(fCo<0);
   jf=find(ffPxy>=0);
   kf=find(ffPxy<0);
   %figure
	%loglog(freq_vector(j),fCo(j),'r.',freq_vector(k),-fCo(k),'b.',ffxy(jf),ffPxy(jf),'*r',ffxy(kf),-ffPxy(kf),'*b');
	%title('Co, Q - Cross and quadrature spectra')
	%xlabel('Frequency')
	P9=ffx;
    
   size(P9)
   P9(2,:)=ffPx';
   P9(3,:)=ffPy';
   P9(4,:)=ffPxy';
   
else
   %P9 = [ [Pxx Pyy Pxy]./KMU];
   end

