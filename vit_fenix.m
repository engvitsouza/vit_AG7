%clc
clear
close all
format long;
ShowPlots = 0;
usaOtimizacaoLocal=1; %coloque 1 para usar conhecimento especialista ou 0 para nao usar
%tic
usaLTE=1; %1 se LTE ou outro para Gaussiana

if usaLTE == 1
    K=2; %dimensao do espaco
    x = read_signal('..\LTEsignals\s_25RBs\s_25RBs_real.dat.norm');
    %load s_25RBs.mat
    %x=real(lte_signal_cp_less(:)); %o imaginario fica para testes
    %x=x/mean(abs(x)); %normaliza potencia
    numDeFrames=floor(length(x)/K);
    if numDeFrames > 5e4
        numDeFrames=5e4;
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

%maximo e minimo para codificacao binaria. Assume que a faixa
%dinamica dos numeros eh de -xmax a xmax
%xmax=max(abs(espaco_total(:))); %valor de pico, absoluto
%b=16; %numero de bits para codificacao binaria
%delta=abs((2*xmax)/((2^b)-1)); %quantization step

tam_code_book = 4096; % numero de centros que procuro
num_experimentos = 5;
num_geracoes = 3;
numInd = 10; %numero de individuos a cada iteracao AG (populacao)
nRing = 2;

Tcruz = 0.1;
desvio = 2; %if(rand < Tmutacao) p2(j,:,i) = p(j,:,i) + (desvio * randn(1,b));
Tmut = 0.9;

melhoresDicionariosPorExperimento=zeros(tam_code_book,K,num_experimentos);
melhoresAptidoesPorExperimento=zeros(1,num_experimentos);

for numExperimento=1:num_experimentos
    fitnessMedia=zeros(1,num_geracoes); %armazena media das fitnesses
    fitnessMelhor=zeros(1,num_geracoes); %armazena fitness do melhor dicionario
    p0 = vit_inicia_populacao4(espaco_total,numInd ,tam_code_book); % ok
    %f_p0 = vit_avalia_populacao3(p0, espaco_total);
    %disp(['Fitness media dos ' num2str(tam_code_book) ...
    %    ' dicionarios iniciais = ' num2str(mean(f_p0))])
    %disp(['Fitness do melhor dicionario inicial = ' num2str(min(f_p0))])
    if ShowPlots==1, clf; vit_plotaPopulacao(p0); title('Inicial'); pause; end
    
    for g = 1:num_geracoes
        %p0 é a inicial e p1 é a que será gerada nesta iteração
        f_p0 = vit_avalia_populacao3(p0, espaco_total);
        
        %p2 = seleciona_pais(p1, f_p1, nRing);
        %p3 = vit_cross_over2(p2,Tcruz);
        p1 = vit_cross_over2(p0,Tcruz);
        if ShowPlots==1, clf; vit_plotaPopulacao(p1); title('Crossover'); pause, end
        if usaOtimizacaoLocal == 1
            [f_p1, p1]= vit_avalia_populacaoEOtimizaLocalmenteComKmeans(p1, espaco_total);
            if ShowPlots==1, clf; vit_plotaPopulacao(p1); title('Otimizacao local'); pause, end
        else
            f_p1 = vit_avalia_populacao3(p1, espaco_total);
        end
        %p1 = vit_mutation3(p1,desvio,Tmut); %mesmo fator pra um vetor do dicionario
        p1 = vit_mutation4(p1,desvio,Tmut); %mesmo fator pra todo dicionario
        if ShowPlots==1, clf; vit_plotaPopulacao(p1); title('Mutacao'); pause, end
        if usaOtimizacaoLocal == 1
            [f_p1, p1]= vit_avalia_populacaoEOtimizaLocalmenteComKmeans(p1, espaco_total);
            if ShowPlots==1, clf; vit_plotaPopulacao(p1); title('Otimizacao local'); pause, end
        else
            f_p1 = vit_avalia_populacao3(p1, espaco_total);
        end
        [p1, f_p1] = vit_elistimo2(p0, f_p0, p1, f_p1);
        if ShowPlots==1, clf, vit_plotaPopulacao(p1); clf; vit_plotaPopulacao(p1); title('Elitismo'); pause, end
        %caso queira plotar os dicionarios:
        %figure(g); clf; vit_plotaPopulacao(p1); %pause
        fitnessMedia(g)=mean(f_p1);
        fitnessMelhor(g)=min(f_p1);
        disp(['Geracao=' num2str(g) ...
            '. Aptidoes: media=' num2str(fitnessMedia(g)) ...
            ' e melhor=' num2str(fitnessMelhor(g))])
        %prepara para proxima iteracao
        p0=p1;
    end
    
    %extrai o melhor dicionario. lembrar que:
    %populacao=zeros(tam_code_book,K, numInd);
    [minDistancia,minIndex]=min(f_p1);
    if minDistancia ~= fitnessMelhor(num_geracoes)
        error('minDistancia ~= fitnessMelhor(num_geracoes)');
    end
    melhoresDicionariosPorExperimento(:,:,numExperimento)=p1(:,:,minIndex);
    melhoresAptidoesPorExperimento(numExperimento)=minDistancia;
    
    if ShowPlots==1
        %plot(f_p1, 'bo')
        figure(1), clf;
        plot(fitnessMelhor);
        hold on
        plot(fitnessMedia,'r');
        legend('melhor','media');
        xlabel('Geracao AG')
        ylabel('Aptidoes');
        
        figure(2), clf;
        vit_plotaPopulacao(p1); %plota populacao final
        title('Populacao final')
    end
end

%extrai o melhor dicionario entre todos experimentos
%populacao=zeros(tam_code_book,K, numInd);
[minDistancia,minIndex]=min(melhoresAptidoesPorExperimento);
dicionarioAG=melhoresDicionariosPorExperimento(:,:,minIndex);

%grava dicionario feito com Kmeans
arquivoSaidaDicionario=['dicionario_ag' num2str(tam_code_book) '.mat'];
save(arquivoSaidaDicionario,'dicionarioAG');
disp(['Wrote ' arquivoSaidaDicionario])
