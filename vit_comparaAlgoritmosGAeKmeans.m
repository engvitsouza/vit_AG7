%para testar e comparar algoritmos Kmeans e GA
usaLTE=1;
numVetoresCodebook=16; %tamanho do dicionario
if usaLTE == 1
    usaConjuntoDeTeste=0; %se 1, usa o de teste, senao, o de treino
    K=2; %dimensao do espaco    
    %load s_25RBs.mat
    if usaConjuntoDeTeste == 1
        x = read_signal('..\LTEsignals\s_25RBs\s_25RBs_imag.dat.norm');        
        %x=imag(lte_signal_cp_less(:)); %imag, pois o real foi usado para treino
    else
        x = read_signal('..\LTEsignals\s_25RBs\s_25RBs_real.dat.norm');        
        %x=real(lte_signal_cp_less(:)); %o real foi usado para treino
    end
    %x=x/mean(abs(x)); %normaliza potencia
    numDeFrames=floor(length(x)/K);
    if numDeFrames > 1e4
        numDeFrames=1e4;
    end
    espaco_total=reshape(x(1:numDeFrames*K),numDeFrames,K);
else
    K=2; %dimensao do espaco
    mu = [2,3];
   % sigma = [1,0.9;0.9,3]; %weak correlation
    sigma = [1,1.5;1.5,3]; %strong correlation
    %nao inicializa com rng default para que seja diferente do treino
    espaco_total = mvnrnd(mu,sigma,1000);
end

%carrega dicionarios ja treinados
load(['dicionario_ag' num2str(numVetoresCodebook) '.mat'])
load(['dicionario_kmeans' num2str(numVetoresCodebook) '.mat'])

[distanciasKmeans,~] = ...
    vit_codificaConjuntoDeVetores(espaco_total, dicionarioKmeans);
[distanciasAG,~] = ...
    vit_codificaConjuntoDeVetores(espaco_total, dicionarioAG);

disp('Distancias medias:')
disp(['Do Kmeans = ' num2str(mean(distanciasKmeans))])
disp(['Do AG = ' num2str(mean(distanciasAG))])
