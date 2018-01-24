clear 
clc 
close all
%as pastas abaixo precisam estar presentes e no mesmo nivel
addpath('../lapse-lte/');
addpath('../compression-utils/');
addpath('../resampling-guo/');

ShowPlots = 0;
disp('Results with resampling only')

%% Files with LTE signals

signal_filePath   = '../LTEsignals/s_50RBs/';
signal_real_filename    = [signal_filePath 's_50RBs_real.dat'];
signal_imag_filename    = [signal_filePath 's_50RBs_imag.dat'];
save_signals_in_a_file = 1;

%names of files
fn_signal_norm_values_real      = [signal_real_filename '.norm'];
fn_signal_norm_values_imag      = [signal_imag_filename '.norm'];
fn_signal_max_values_real      = [signal_real_filename '.max'];
fn_signal_max_values_imag      = [signal_imag_filename '.max'];

file_output_name_mat = 'resampled.mat';


% read signa from files
signal      = read_cplx_signal(signal_real_filename,signal_imag_filename);


%% LTE parameters
% Number of resource blocks in a lte signal
Nrb = 50; 
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


%% resampling parameters
K = 5; %at TX: upsampling factor. at RX: downsampling factor
L = 12; %at TX: downsampling factor. at RX: upsampling factor

% block size
Ns = 32;

%% transmitter compression
vit_tx01;

%% receiver decompression 
vit_rx01;
%% LTE demodulation


time_offset = lteDLFrameOffset(enb_param,signal_quant);
% crio meu sinal inicial (antes da compressao)
signal_deoded = signal(time_offset+1:end);
TX = lteOFDMDemodulate(enb_param,signal);
% sinal final apos a compressao
signal_decoded = signal_rx(time_offset+1:end); zeros(time_offset,1);
RX = lteOFDMDemodulate(enb_param,[signal_quant(time_offset+1:end); zeros(time_offset,1)]);
 

 %discard last slot because first samples are discarded
 TX_valid = TX(:,1:end-1);  
 RX_valid = RX(:,1:end-1);
    
 %error_vector = sum( abs( TX_valid(:) - RX_valid(:) ).^2  ) ;
erro =   sum(abs ( TX_valid(:) -RX_valid(:)).^2);
 
e1 =   sum (abs(TX_valid(:))   .^2  ) ;

amor = sqrt( erro/e1);
 
evm_as_in_si =amor ;
    
 
 
 freq_evms= 100*lte_evm_annexE_36104(RX_valid(:,1:126),TX_valid(:,1:126));
 

 
% evm_as_in_annexE_36104_avg = mean(freq_evms(:));
disp(['EVM = ' num2str( evm_as_in_si) '%'])

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

 
if ShowPlots==1
    lte_plot_tx_vs_rx([signal(:)],[signal_decoded(:)],Nrb,'normal',0,0);
end
