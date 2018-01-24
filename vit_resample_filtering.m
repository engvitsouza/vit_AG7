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

signal_filePath   = '/home/v/Documents/MATLAB/LTEsignals/s_25RBs/';
signal_real_filename    = [signal_filePath 's_25RBs_real.dat'];
signal_imag_filename    = [signal_filePath 's_25RBs_imag.dat'];
save_signals_in_a_file = 1;
signal      = read_cplx_signal(signal_real_filename,signal_imag_filename);
showPlots = 1 ;
%Implementa downsampling + block scaling

%% upsampling
% y = upsample(x,n) increases the sampling rate of x by inserting n – 1 zeros between samples.
K =2;
Hd =lowpassk2; % aqui eu carrego a struct que tá no arquivo
signal_up2  = upsample(signal,K); % quando eu faço uma amostragem eu crio replicas K-1

% filtro para matar replicas
signal_up_filt = filter(Hd.Numerator,1,signal_up2); 
if showPlots == 1
    figure(1) 
    freqz(signal);     % BW = 10 MHz : Fs = 15.36 MHz
    title('BW = 10 MHz : Fs = 15.36 MHz');
    
    figure(2)
    freqz(signal_up2 );% BW = 10MHz :  Fs = 30.7199 MHz mas surge uma replica...logo quero filtrar em BW/2
    title('BW = 10MHz :  Fs = 30.7199 MHz mas surge uma replica...logo quero filtrar em BW/2');
    
    figure(3)
    freqz(signal_up_filt);
    title('sinal anterior que tinha replicas...so que filtrado');
end

%% downsampling do sinal initi
% y = downsample(x,n) decreases the sampling rate of x by keeping every nth sample starting with the first sample
L = 3;

signal_down3  = downsample(signal_up_filt,L);

if showPlots == 1
    figure(4)
    freqz(signal_down3); %BW = 5MHz ...  mas surge uma replica...logo quero filtrar em BW/2
end

sd_i = real(signal_down3);
sd_q = imag(signal_down3);  

sd_i_max = max(abs(sd_i));
sd_q_max = max(abs(sd_q));

A_k = max([sd_i_max ; sd_q_max]);
sd_i_max = A_k;
sd_q_max = A_k;

%Block scaling
sd_i_norm  = bsxfun(@rdivide,sd_i,sd_i_max);
sd_q_norm  = bsxfun(@rdivide,sd_q,sd_q_max);


%% fazendo meus plotes bonitinhos pro  report
N =2^20;
Fs = 5*10e6;

Fs2= Fs*(K/L);


magSIG =abs(fftshift(fft(signal,N)));
ssf = (-N/2:N/2 -1).*(Fs/N);
subplot(2,1,1), plot(ssf,magSIG);
title('A LTE signal of BW = 5MHz before downsampling and filtering');


magSIG2 =abs(fftshift(fft(signal_down3,N)));
ssf = (-N/2:N/2 -1).*(Fs2/N);
subplot(2,1,2), plot(ssf,magSIG2);
title('A LTE signal of BW = 3.33 MHz after downsampling and filtering ');






% %% filter design
% % filter in frequency domain
% %[Hw,w]=freqz(lpf_tx.Numerator,lpf_tx.Denominator);
% %% filtering  resampling TX
% 
% % filtering
% y_tx_u2_filt = filter(lpf_tx.Numerator,lpf_tx.Denominator,signal_up2);
% 
% %% downsampling
% y_tx_u2_d3 = downsample(y_tx_u2_filt,L);
% 
% sd   = reshape(y_tx_u2_d3(:),Ns,[]);
% sd_i = real(sd);
% sd_q = imag(sd);
% %TODO: quantize sd max
% sd_i_max = max(abs(sd_i));
% sd_q_max = max(abs(sd_q));
% A_k = max([sd_i_max ; sd_q_max]);
% sd_i_max = A_k;
% sd_q_max = A_k;
% %TODO: quantize sd max
% 
% %Block scaling
% sd_i_norm  = bsxfun(@rdivide,sd_i,sd_i_max);
% sd_q_norm  = bsxfun(@rdivide,sd_q,sd_q_max);
% 
% if 0 %used for scalar quantization, not needeed for VQ
%     %sd_i_norm_quant = quantize_sq(sd_i_norm,-1,1,Qq);
%     %sd_q_norm_quant = quantize_sq(sd_q_norm,-1,1,Qq);
%     [sd_i_norm_quant,sd_i_norm_quant_ind,quantizerLevels] =...
%         ak_quantizer2(sd_i_norm,Qq,-1,1,1);
%     [sd_q_norm_quant,sd_q_norm_quant_ind,quantizerLevels] =...
%         ak_quantizer2(sd_q_norm,Qq,-1,1,1);
% end
% 
% %% Save files
% if (save_signals_in_a_file == 1)
%     save_cplx_signal(y_tx_u2_d3,signal_txout_filename_real,signal_txout_filename_imag,'float');
%     save([signal_filePath file_output_name_mat]);
%     
%     %sinal quantizado
%     %save_signal(sd_i_norm_quant(:),fn_signal_norm_values_real,'float');
%     %save_signal(sd_q_norm_quant(:),fn_signal_norm_values_imag,'float');
%     
%     %sinal apenas normalizado por block scaling (nao quantizado)
%     save_signal(sd_i_norm(:),fn_signal_norm_values_real,'float');
%     save_signal(sd_q_norm(:),fn_signal_norm_values_imag,'float');
%     
%     save_signal(sd_i_max,fn_signal_max_values_real,'float');
%     save_signal(sd_q_max,fn_signal_max_values_imag,'float');
% end
% 
% if ShowPlots==1
%     %% plot PSDs
%     
%     % In all upsampled versions, note that the sampling frequency was doubled
%     % as well as the number of FFT points such that the frequency spacing
%     % remains in 15 KHz.
%     [psd_signal,w_orig] = pwelch(signal,enb.FFT_size);
%     
%     figure(61);
%     plot(w_orig/pi,10*log10(psd_signal));
%     title('PSD of signal');
%     xlabel('rad');
%     
%     [psd_tx_u2, w_up2_tx] = pwelch(signal_up2,2*enb.FFT_size);
%     
%     figure(62);
%     plot(w_up2_tx/pi,10*log10(psd_tx_u2));
%     title('PSD of signal upsampled by 2');
%     xlabel('rad');
%     
%     [psd_tx_u2_filtered,w_u2_filt] = pwelch(y_tx_u2_filt,enb.FFT_size);
%     
%     figure(63);
%     plot(w_u2_filt/pi,10*log10(psd_tx_u2_filtered));
%     title('PSD of signal resampled by 2 and filtered');
%     xlabel('rad');
%     
%     [psd_tx_u2_d3,w_u2_d3_tx] = pwelch(y_tx_u2_d3,enb.FFT_size);
%     
%     figure(64);
%     plot(w_u2_filt/pi,10*log10(psd_tx_u2_d3));
%     title('PSD of signal resampled by 2/3');
%     xlabel('rad');
% end