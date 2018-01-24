clear;
%as pastas abaixo precisam estar presentes e no mesmo nivel
addpath('../lapse-lte/');
addpath('../compression-utils/');
addpath('../resampling-guo/');

%dicionario para QV
%arquivoComDicionario='dicionario_ag16.mat';
arquivoComDicionario='dicionario_kmeans4096.mat';
%arquivoComDicionario='dicionario_kmeans256.mat';
%arquivoComDicionario='dicionario_kmeans1024.mat';
ShowPlots = 0;
useResamplingOnly=1; %1 significa testar apenas com resampling, sem quantizacao. Use 0 para QV

if useResamplingOnly==1
    disp('Results with resampling only')
else
    disp('Results with resampling + block scaling + vector quantization')
end

%% Files with LTE signals

%signal_filePath   = '.\s5\';
%signal_filePath   = '.\lte_signal\s1\';
%signal_filePath   = '.\lte_signal_paper\';
signal_filePath   = '../LTEsignals/s_25RBs/';

signal_real_filename    = [signal_filePath 's_25RBs_real.dat'];
signal_imag_filename    = [signal_filePath 's_25RBs_imag.dat'];

save_signals_in_a_file = 1;

signal_txout_filename_real = [signal_real_filename '.res'];
signal_txout_filename_imag = [signal_imag_filename '.res'];

fn_signal_norm_values_real      = [signal_real_filename '.norm'];
fn_signal_norm_values_imag      = [signal_imag_filename '.norm'];
fn_signal_max_values_real      = [signal_real_filename '.max'];
fn_signal_max_values_imag      = [signal_imag_filename '.max'];

file_output_name_mat = 'resampled.mat';

if 1
    % read signal from files
    signal      = read_cplx_signal(signal_real_filename,signal_imag_filename);
else
    % read signal from .mat
    tmp_mat = load('../lte-lpc-ul/x_ul_sim.mat');
    signal  = tmp_mat.x_withcp;
end


%% LTE parameters
% Number of resource blocks in a lte signal
Nrb = 25; 
cp_type = 'Normal';

% The lte parameters below at LTE demodulation. Note that NcellID is
% fundamental to demodulate the signal.
enb_param.NDLRB         = Nrb;
enb_param.CyclicPrefix  = cp_type;
enb_param.NCellID       = 0;
enb_param.DuplexMode    = 'FDD';
enb_param.NSubframe     = 0;
enb_param.CellRefP      = 1;

%% 
enb         = lte_DLPHYparam(Nrb,cp_type);
N_cp_l_0    = enb.cp_0_length;
N_cp_l_else = enb.cp_else_length;
N_dl_symb   = enb.N_dl_symb;
FFT_size    = enb.FFT_size;

%% quantization parameters

% block size
Ns = 32; 

% number of bits of original samples
Qs = 15; 

% number of bits used to quantize the scaled samples
% when using scalar quantization
% it is not used for QV
%Qq = 6;  

%% resampling parameters
K = 2; %at TX: upsampling factor. at RX: downsampling factor
L = 3; %at TX: downsampling factor. at RX: upsampling factor

%% filter parameters

%lpf_rx = fir_lpf_ls_64th;
%lpf_rx = fir_lpf_ls_64th_wp03_ws037;
%lpf_rx = fir_lpf_ls_128th_wp03_ws037;

% it looks near the lpf used in Guo13
lpf_rx = fir_lpf_kaiser_window_Fpass9MHz_Fstop11_85_Fs61_44; 

%lpf_tx = fir_lpf_ls_64th;
%lpf_tx = fir_lpf_ls_64th_wp03_ws037;
%lpf_tx = fir_lpf_ls_128th_wp03_ws037;

% it looks near the lpf used in Guo13
lpf_tx = fir_lpf_kaiser_window_Fpass9MHz_Fstop11_85_Fs61_44;

%filters_delay    = 64;
filters_delay    = 32;

%% compression ratio calculation for scalar quantization
%Cratio = ((K/L)*Ns*Qq + Qs)/(Ns*Qs);


%% transmitter compression
%vit_resample_tx_comp;
%vit_resampling_15_16
%vit_resampling_15_28
%vit_resampling_15_32
%vit_resampling_2_3
%vit_resampling_3_4
%vit_resampling_5_12
vit_resampling_5_8


%% receiver decompression (com quantizacao vetorial)
vit_resample_rx_decomp;

%% LTE demodulation
% you can disable this part of toolbox if you dont have the lte toolbox of
% matlab
if 1
    
    time_offset = lteDLFrameOffset(enb_param,signal_quant);
    signal_deoded = signal_quant(time_offset+1:end);
     % esse eh o sinal inicial que ta sendo demodulado para calcular EVM
    TX = lteOFDMDemodulate(enb_param,signal);
    
    signal_decoded = signal_quant(time_offset+1:end); zeros(time_offset,1);
    
    % eesse eh o sinal quantizado 
    RX = lteOFDMDemodulate(enb_param,[signal_quant(time_offset+1:end); zeros(time_offset,1)]);
    
    % Estimate channel and noise
    [Hest Nest] = lteDLChannelEstimate(enb_param,RX);
 
   
    
    % discard last slot because first samples are discarded
    TX_valid = TX(:,1:end-1);  
    RX_valid = RX(:,1:size(TX_valid,2)); % gambis para proteger o codigo quando der diferente)
    
    error_vector = RX_valid(:) - TX_valid(:);
    
   evm_as_in_guo = 100*sqrt(mean(abs(error_vector).^2)/mean(abs(TX_valid(:)).^2))
    
    
    freq_evms= 100*lte_evm_annexE_36104(RX_valid(:,1:126),TX_valid(:,1:126));
    
    evm_as_in_annexE_36104_avg = mean(freq_evms(:));
    disp(['EVM = ' num2str(evm_as_in_annexE_36104_avg ) '%'])

    if ShowPlots==1
        figure;
        plot(freq_evms);
        xlabel('resource block number');
        ylabel('EVM(%)');
        title('Each line is a subframe');

        [N,C]=hist(freq_evms(:),100);
        figure;
        plot(C,N);
        xlabel('EVM(%)');
        ylabel('Number of occurrences');
    end
end
if ShowPlots==1
    lte_plot_tx_vs_rx([signal(:)],[signal_decoded(:)],Nrb,'normal',0,0);
end
