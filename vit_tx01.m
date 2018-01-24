%Implementa downsampling  + block scaling

%% filter parameters
% it looks near the lpf used in Guo13
lpf_tx = fir_lpf_kaiser_window_Fpass9MHz_Fstop11_85_Fs61_44;

%filters_delay    
filters_delay    = 32;

%% upsampling
signal_up2  = upsample(signal,K);

%% filter design
% filter in frequency domain
%[Hw,w]=freqz(lpf_tx.Numerator,lpf_tx.Denominator);

%% filtering  resampling TX

% filtering
y_tx_u2_filt = filter(lpf_tx.Numerator,lpf_tx.Denominator,signal_up2);

%% downsampling
y_tx_u2_d3 = downsample(y_tx_u2_filt,L);

sd   = reshape(y_tx_u2_d3(:),Ns,[]);
sd_i = real(sd);
sd_q = imag(sd);
%TODO: quantize sd max
sd_i_max = max(abs(sd_i));
sd_q_max = max(abs(sd_q));
A_k = max([sd_i_max ; sd_q_max]);
sd_i_max = A_k;
sd_q_max = A_k;
%TODO: quantize sd max

%Block scaling
sd_i_norm  = bsxfun(@rdivide,sd_i,sd_i_max);
sd_q_norm  = bsxfun(@rdivide,sd_q,sd_q_max);

%% Save files
if (save_signals_in_a_file == 1)
 
    %sinal apenas normalizado por block scaling (nao quantizado)
    save_signal(sd_i_norm(:),fn_signal_norm_values_real,'float');
    save_signal(sd_q_norm(:),fn_signal_norm_values_imag,'float');
    
    save_signal(sd_i_max,fn_signal_max_values_real,'float');
    save_signal(sd_q_max,fn_signal_max_values_imag,'float');
end

if ShowPlots==1
    %% plot PSDs
    
    % In all upsampled versions, note that the sampling frequency was doubled
    % as well as the number of FFT points such that the frequency spacing
    % remains in 15 KHz.
    [psd_signal,w_orig] = pwelch(signal,enb.FFT_size);
    
    figure(61);
    plot(w_orig/pi,10*log10(psd_signal));
    title('PSD of signal');
    xlabel('rad');
    
    [psd_tx_u2, w_up2_tx] = pwelch(signal_up2,2*enb.FFT_size);
    
    figure(62);
    plot(w_up2_tx/pi,10*log10(psd_tx_u2));
    title('PSD of signal upsampled by 2');
    xlabel('rad');
    
    [psd_tx_u2_filtered,w_u2_filt] = pwelch(y_tx_u2_filt,enb.FFT_size);
    
    figure(63);
    plot(w_u2_filt/pi,10*log10(psd_tx_u2_filtered));
    title('PSD of signal resampled by 2 and filtered');
    xlabel('rad');
    
    [psd_tx_u2_d3,w_u2_d3_tx] = pwelch(y_tx_u2_d3,enb.FFT_size);
    
    figure(64);
    plot(w_u2_filt/pi,10*log10(psd_tx_u2_d3));
    title('PSD of signal resampled by 2/3');
    xlabel('rad');
end