function Hd = K15_fir_lpf_kaiser_window_Fpass22_5MHz_Fstop23_75_Fs153_60
%K15_FIR_LPF_KAISER_WINDOW_FPASS22_5MHZ_FSTOP23_75_FS153_60 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.2 and the Signal Processing Toolbox 7.4.
% Generated on: 20-Jan-2018 00:29:44

% FIR Window Lowpass filter designed using the FIR1 function.

% All frequency values are in MHz.
Fs = 153.6;  % Sampling Frequency

Fpass = 22.5;            % Passband Frequency
Fstop = 23.75;           % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
flag  = 'scale';         % Sampling Flag

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([Fpass Fstop]/(Fs/2), [1 0], [Dstop Dpass]);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dfilt.dffir(b);

% [EOF]
