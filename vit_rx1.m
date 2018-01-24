%% resampling parameters
K = 2; %at TX: upsampling factor. at RX: downsampling factor
L = 3; %at TX: downsampling factor. at RX: upsampling factor

%% filter parameters

% it looks near the lpf used in Guo13
lpf_rx = fir_lpf_kaiser_window_Fpass9MHz_Fstop11_85_Fs61_44; 


% it looks near the lpf used in Guo13
lpf_tx = fir_lpf_kaiser_window_Fpass9MHz_Fstop11_85_Fs61_44;


filters_delay    = 32;



%%  LTE config
enb         = lte_DLPHYparam(Nrb,cp_type);

%% filter design

% filter in frequency domain
[Hw,w]=freqz(lpf_rx.Numerator,lpf_rx.Denominator);

if 0
    %% Read original signal and output of VQ
    signal      = read_cplx_signal(signal_real_filename,signal_imag_filename);
    signal_down_rx   = read_cplx_signal(signal_txout_filename_real,signal_txout_filename_imag);
    
  
    %% Block deScaling. Get signals from files
    sd_i_norm_quant_tmp = read_signal(fn_signal_norm_values_real);
    sd_q_norm_quant_tmp = read_signal(fn_signal_norm_values_imag);
    
    sd_i_max_rx = transpose(read_signal(fn_signal_max_values_real));
    sd_q_max_rx = transpose(read_signal(fn_signal_max_values_imag));
    
    sd_i_norm_quant_rx = reshape(sd_i_norm_quant_tmp,Ns,[]);
    sd_q_norm_quant_rx = reshape(sd_q_norm_quant_tmp,Ns,[]);
end
%%
% Get block scaled samples
if useResamplingOnly==1
    %no quantization at all
    sd_i_norm_quant_rx = sd_i_norm;
    sd_q_norm_quant_rx = sd_q_norm;
else
    %vector quantization
    disp('Iniciando quantizacao vetorial...')
    load(arquivoComDicionario);
    if ~exist('dicionarioAG')
        %se nao tem AG foi usado K-means
        dicionarioAG=dicionarioKmeans;
    end
    sd_i_norm_quant_rx = ...
        vit_quantizaVetorialmenteConjuntoDeVetores(sd_i_norm, dicionarioAG);
    sd_q_norm_quant_rx = ...
        vit_quantizaVetorialmenteConjuntoDeVetores(sd_q_norm, dicionarioAG);
    disp('Terminou a quantizacao vetorial')
end

% Get scaling values
sd_i_max_rx = sd_i_max;
sd_q_max_rx = sd_q_max;

sd_i_rx =  bsxfun(@times,sd_i_norm_quant_rx,sd_i_max_rx);
sd_q_rx =  bsxfun(@times,sd_q_norm_quant_rx,sd_q_max_rx);

signal_down_rx = complex(sd_i_rx(:),sd_q_rx(:));
%% Resampling on receiver
y_rx_up3    = upsample(signal_down_rx,L);

% take into account resampling of TX and RX
%y_rx_up3_filtered = (L*K)*filter(lpf_rx.Numerator,lpf_rx.Denominator,y_rx_up3);
y_rx_up3_filtered = (L*K)*conv(lpf_rx.Numerator,y_rx_up3,'full');
signal_quant    = downsample(y_rx_up3_filtered,K);

% Skip first samples of remsampled signal, such that the ''transient''
% region of filtes are not taken into account.
signal_rx       = [signal_quant(filters_delay+1:end) ; zeros(filters_delay,1)];
%% plot PSDs

if 0
    [psd_signal,w_orig] = pwelch(signal,enb.FFT_size);
    figure(61);
    plot(w_orig/pi,psd_signal);
    title('PSD of signal');
    xlabel('rad');
end

if 0
    [psd_tx_u2, w_up2_tx] = pwelch(signal_up2,2*enb.FFT_size);
    
    figure(62);
    plot(w_up2_tx/pi,psd_tx_u2);
    title('PSD of signal upsampled by 2');
    xlabel('rad');
end

if 0
    [psd_tx_u2_filtered,w_u2_filt] = pwelch(y,enb.FFT_size);
    
    figure(63);
    plot(w_u2_filt/pi,10*log10(psd_tx_u2_filtered));
    title('PSD of signal resampled by 2 and filtered');
    xlabel('rad');
end

if 0
    [psd_tx_u2_d3,w_u2_d3_tx] = pwelch(y_tx_u2_d3,enb.FFT_size);
    
    figure(64);
    plot(w_u2_d3_tx/pi,10*log10(psd_tx_u2_d3));
    title('PSD of signal resampled by 2/3');
    xlabel('rad');
end

if ShowPlots == 1

[psd_rx_u3, w_u3_rx] = pwelch(y_rx_up3,2*enb.FFT_size);

figure(71);
plot(w_u3_rx/pi,10*log10(psd_rx_u3));
title('PSD of received signal resampled by 3');
xlabel('rad');


[psd_rx_u3_filt, w_u3_filt] = pwelch(y_rx_up3_filtered,2*enb.FFT_size);

figure(72);
plot(w_u3_filt/pi,10*log10(psd_rx_u3_filt));
title('PSD of received signal resampled by 3 and filtered');
xlabel('rad');

[psd_rx_u3_d2, w_rx_u3_d2] = pwelch(signal_quant,enb.FFT_size);

figure(73);
plot(w_rx_u3_d2/pi,10*log10(psd_rx_u3_d2));
title('PSD of reconstruced signal');
xlabel('rad');

end

%aqui tah plotando EVM
lte_SNRPerOFDMSymbol(signal,[signal_quant(filters_delay+1:end) ; zeros(filters_delay,1)],Nrb,'Normal',0,0,1);

if 0
    figure(54);
    subplot(3,1,1);
    plot(w/pi,20*log10(abs(Hw)));
    xlabel(xlabel_digital_freq);
    ylabel('Magnitude (dB)');
    ylim([-65 5]);
    grid minor;
    
    subplot(3,1,2);
    plot(w/pi,180*phase(Hw)/pi);
    ylabel('Phase (deg)');
    xlabel(xlabel_digital_freq);
    grid minor;
    
    subplot(3,1,3);
    [gd,w] = grpdelay(lpf_rx.Numerator,lpf_rx.Denominator);
    plot(w/pi,gd);
    ylabel('Group Delay (samples)');
    xlabel(xlabel_digital_freq);
    ylim([0 10]);
    
    grid minor;
end