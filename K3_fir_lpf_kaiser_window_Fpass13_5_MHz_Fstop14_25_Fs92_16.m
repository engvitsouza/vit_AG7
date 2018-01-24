function Hd = K3_fir_lpf_kaiser_window_Fpass13_5_MHz_Fstop14_25_Fs92_16
%K3_FIR_LPF_KAISER_WINDOW_FPASS13_5_MHZ_FSTOP14_25_FS92_16 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.2 and the Signal Processing Toolbox 7.4.
% Generated on: 20-Jan-2018 00:27:22

% FIR Window Lowpass filter designed using the FIR1 function.

% All frequency values are in MHz.
Fs = 92.16;  % Sampling Frequency

Fpass = 13.5;            % Passband Frequency
Fstop = 14.25;           % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
flag  = 'scale';         % Sampling Flag

% Calculate the order from the parameters using KAISERORD.
[N,Wn,BETA,TYPE] = kaiserord([Fpass Fstop]/(Fs/2), [1 0], [Dstop Dpass]);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Wn, TYPE, kaiser(N+1, BETA), flag);
Hd = dfilt.dffir(b);

% [EOF]