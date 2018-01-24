clc
close all
clear all
% Select the number of resource blocks (Bandwidth)
% 100   : BW=  20 MHz : Fs= 30.72 MHz
% 75    : BW=  15 MHz : Fs= 23.04 MHz
% 50    : BW=  10 MHz : Fs= 15.36 MHz
% 25    : BW=   5 MHz : Fs=  7.68 MHz
% 15    : BW=   3 MHz : Fs=  3.84 MHz
% 6     : BW= 1.4 MHz : Fs=  1.92 MHz

%% Block DEscaling

sd_i = bsxfun(@times, sd_i_norm ,A_k);
sd_q = bsxfun(@times, sd_q_norm ,A_k);




















signal_filePath   = '../LTEsignals/s_25RBs/';
signal_real_filename    = [signal_filePath 's_25RBs_real.dat'];
signal_imag_filename    = [signal_filePath 's_25RBs_imag.dat'];
save_signals_in_a_file = 1;
signal      = read_cplx_signal(signal_real_filename,signal_imag_filename);
showPlots = 0;
%Implementa downsampling + block scaling

%% upsampling
% y = upsample(x,n) increases the sampling rate of x by inserting n – 1 zeros between samples.
K =2;
Hd =lowpassk2;
signal_up2  = upsample(signal,K); % quando eu faço uma amostragem eu crio replicas K-1

% filtro para matar replicas
signal_up_filt = filter(Hd.Numerator,1,signal_up2); 
if showPlots == 1
    figure(1) 
    freqz(signal);     % BW = 10 MHz : Fs = 15.36 MHz

    figure(2)
    freqz(signal_up2 );% BW = 10MHz :  Fs = 30.7199 MHz mas surge uma replica...logo quero filtrar em BW/2

    figure(3)
    freqz(signal_up_filt);
end

%% downsampling do sinal initi
% y = downsample(x,n) decreases the sampling rate of x by keeping every nth sample starting with the first sample
L = 3;
signal_down3  = downsample(signal_up_filt,L);

if showPlots == 1
    figure(4)
    freqz(signal_down3); %BW = 5MHz ...  mas surge uma replica...logo quero filtrar em BW/2
end



