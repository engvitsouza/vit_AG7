clear all
close all
clc

%% THIS CODE EVALUTE ONLY DOWNSAMPLING EFECT
ShowPlots = 1;
disp('Results with resampling only')
useResamplingOnly =1;
save_signals_in_a_file = 0;
%% Files with LTE signals
signal_filePath   = '../LTEsignals/s_25RBs/';
signal_real_filename    = [signal_filePath 's_25RBs_real.dat'];
signal_imag_filename    = [signal_filePath 's_25RBs_imag.dat'];

 % read signal from files
 signal   = read_cplx_signal(signal_real_filename,signal_imag_filename);


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
enb         = lte_DLPHYparam(Nrb,cp_type);
N_cp_l_0    = enb.cp_0_length;
N_cp_l_else = enb.cp_else_length;
N_dl_symb   = enb.N_dl_symb;
FFT_size    = enb.FFT_size;

%% quantization parameters

% block size
Ns = 32; 

%% transmitter compression
vit_tx;

%% receiver decompression (com quantizacao vetorial)
vit_rx;

%% LTE demodulation
time_offset = lteDLFrameOffset(enb_param,signal_quant);
signal_deoded = signal_quant(time_offset+1:end);
TX = lteOFDMDemodulate(enb_param,signal);
signal_decoded = signal_quant(time_offset+1:end); zeros(time_offset,1);
RX = lteOFDMDemodulate(enb_param,[signal_quant(time_offset+1:end); zeros(time_offset,1)]);
 
% discard last slot because first samples are discarded
TX_valid = TX(:,1:end-1);  
RX_valid = RX(:,1:end-1);
   
error_vector = RX_valid(:) - TX_valid(:);
    
%evm_as_in_guo = 100*sqrt(mean(abs(error_vector).^2)/...
%    mean(abs(TX_valid(:)).^2));
    
freq_evms= 100*lte_evm_annexE_36104(RX_valid(:,1:126),TX_valid(:,1:126));
    
evm_as_in_annexE_36104_avg = mean(freq_evms(:));
disp(['EVM = ' num2str(evm_as_in_annexE_36104_avg ) '%'])

if ShowPlots == 1
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

%lte_plot_tx_vs_rx([signal(:)],[signal_decoded(:)],Nrb,'normal',0,0);

