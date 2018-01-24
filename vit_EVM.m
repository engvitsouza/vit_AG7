% eNodeB Configuration 
rng('default');         % Set the default random number generator
rmc = lteRMCDL('R.5');  % Configure RMC
rmc.PDSCH.RVSeq = 0;    % Redundancy version indicator
rmc.TotSubframes = 20;  % Total number of subframes to generate

% Create eNodeB transmission with random PDSCH data
txWaveform = lteRMCDLTool(rmc,randi([0 1],rmc.PDSCH.TrBlkSizes(1),1));

%%  Impairment Modeling
% Model the transmitter EVM and add frequency and IQ offsets.

% Model EVM with additive noise
ofdmInfo   = lteOFDMInfo(rmc);        
txEVMpc    = 1.2;          % Transmit EVM in per cent
evmModel   = txEVMpc/(100*sqrt(double(ofdmInfo.Nfft)))* ...
    complex(randn(size(txWaveform)),randn(size(txWaveform)))/sqrt(2);
rxWaveform = txWaveform+evmModel;    

% Add frequency offset impairment to received waveform
foffset    = 33.0;         % Frequency offset in Hertz
t = (0:length(rxWaveform)-1).'/ofdmInfo.SamplingRate;
rxWaveform = rxWaveform.*repmat(exp(1i*2*pi*foffset*t),1,rmc.CellRefP);

% Add IQ offset
iqoffset   = complex(0.01,-0.005);
rxWaveform = rxWaveform+iqoffset;

%%  Receiver
% The receiver synchronizes with the received signal and computes and
% displays the measured EVM.

% Apply frequency estimation and correction for the purposes of performing
% timing synchronization
foffset_est = lteFrequencyOffset(rmc,rxWaveform);
rxWaveformFreqCorrected = lteFrequencyCorrect(rmc,rxWaveform,foffset_est);

% Synchronize to received waveform    
offset = lteDLFrameOffset(rmc,rxWaveformFreqCorrected,'TestEVM');    
rxWaveform = rxWaveform(1+offset:end,:);

% Use 'TestEVM' pilot averaging
cec.PilotAverage = 'TestEVM';

%% Perform Measurements
% The PDSCH EVM is calculated by calling |hPDSCHEVM|.
%
% The average EVM for a downlink RMC is displayed. First the results for
% low and high edge EVM are calculated for each subframe within a frame and
% their averages are displayed at the command window. The max of these
% averages is the EVM per frame. The final EVM for the downlink RMC is the
% average of the EVM across all frames. A number of plots are also
% produced:
%
% * EVM versus OFDM symbol
% * EVM versus subcarrier
% * EVM versus resource block
% * EVM versus OFDM symbol and subcarrier (i.e. the EVM resource grid)
%
% Note that the EVM measurement displayed at the command window is only
% calculated across allocated PDSCH resource blocks, in accordance with the
% LTE standard. The EVM plots are shown across all resource blocks
% (allocated or unallocated), allowing the quality of the signal to be
% measured more generally. In unallocated resource blocks, the EVM is
% calculated assuming that the received resource elements have an expected
% value of zero.
%
% The EVM of each E-UTRA carrier for QPSK, 16QAM and 64QAM modulation
% schemes on PDSCH should be better than the required EVM of 17.5%, 12.5%
% and 8% respectively as per TS36.104 Table 6.5.2-1 [ <#7 1> ].

% Compute and display EVM measurements
[evmmeas, plots] = hPDSCHEVM(rmc,cec,rxWaveform);    

%% Appendix
% This example uses the following helper functions:
%
% * <matlab:edit('hPDSCHEVM.m') hPDSCHEVM.m>

%% Selected Bibliography
% # 3GPP TS 36.104 "Base Station (BS) radio transmission and reception"
% # 3GPP TS 36.141 "Base Station (BS) conformance testing"
% # 3GPP TS 36.101 "User Equipment (UE) radio transmission and reception"

displayEndOfDemoMessage(mfilename) 




