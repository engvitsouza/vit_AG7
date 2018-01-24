%projeto de dicionario com kmeans
if 1
    %usar dimensoes do artigo
    b=12; %numero de bits usado no paper, onde b=Qvq*Lvq, com Qvq=6 e Lvq=2
    numVetoresCodebook=2^b; %numero de vetores no dicionario
else
    numVetoresCodebook=1024;
end
rng(1); % For reproducibility
usaLTE=1; %1 se LTE ou outro para Gaussiana

if usaLTE == 1
    K=2; %dimensao do espaco
    x = read_signal('..\LTEsignals\s_25RBs\s_25RBs_real.dat.norm');        
    %load s_25RBs.mat
    %x=real(lte_signal_cp_less(:)); %podia ser o imaginario
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
    rng default  % para que o espaco de busca seja sempre o mesmo
    espaco_total = mvnrnd(mu,sigma,1000);
end

%projeto usando K-means (tambem chamado algoritmo de Lloyd)
[indices,dicionarioKmeans] = kmeans(espaco_total,numVetoresCodebook);

[distanciasKmeans,~] = ...
    vit_codificaConjuntoDeVetores(espaco_total, dicionarioKmeans);

disp(['Distancia media do Kmeans = ' num2str(mean(distanciasKmeans))])

%grava dicionario feito com Kmeans
save(['dicionario_kmeans' num2str(numVetoresCodebook) '.mat'],'dicionarioKmeans');

clf
plot(espaco_total(:,1),espaco_total(:,2),'rx')
hold on
plot(dicionarioKmeans(:,1),dicionarioKmeans(:,2),'bo')
voronoi(dicionarioKmeans(:,1),dicionarioKmeans(:,2))
title('Conjunto de treino e dicionario final')