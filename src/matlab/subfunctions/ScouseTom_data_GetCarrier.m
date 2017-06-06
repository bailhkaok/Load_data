function [ Fc ] = ScouseTom_data_GetCarrier( data,Fs )
%get carrier frequency of data
% Assumes only one carrier frequency
%   finds the largest frequency bin in a data set. Zero pads the result to
%   give smaller frequency bins for short signals for a more accurate
%   result.
% Adapted from G Dragons Code by the sonorous and majestic Jimmy

% this is not a very robust bit of code at the moment, if data is fucked
% then this doesnt know, and at the moment there are no checks to see if it
% matches the *expected* freq

V=detrend(data);
N = length(V);

NFFT = max([2^24 2^nextpow2(length(V))]); % Next power of 2 from length of y
Y = fft(V,NFFT)/N;
F = Fs/2*linspace(0,1,NFFT/2+1);

Ymag=2*abs(Y(1:NFFT/2+1));

[~,maxw] = max(Ymag);
%find carrier one
Fc = F(maxw);

% %parabolic fit from
% %https://ccrma.stanford.edu/~jos/sasp/Matlab_Parabolic_Peak_Interpolation.html,
% %could just use polyfit
% 
% y0 = (Ymag(maxw));
% ym1 = (Ymag(maxw-1));
% yp1 = (Ymag(maxw+1));
% 
% p = (yp1 - ym1)/(2*(2*y0 - yp1 - ym1)); 
% y = y0 - 0.25*(ym1-yp1)*p;

%display message to user
fprintf('Carrier frequency detected: Fc = %.2f Hz\r',Fc);

end
