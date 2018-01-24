clc 
clear
close all
format long;    
ShowPlots = 1;
%tic
mu = [2,3];
sigma = [1,1.5;1.5,3];
rng default  % para que o espaco de busca seja sempre o mesmo
espaco_total = mvnrnd(mu,sigma,1000);

%maximo e minimo para codificacao binaria. Assume que a faixa
%dinamica dos numeros eh de -xmax a xmax
xmax=max(abs(espaco_total(:))); %valor de pico, absoluto
b=16; %numero de bits para codificacao binaria
delta=abs((2*xmax)/((2^b)-1)); %quantization step
tam_code_book = 8; % numero de centros que procuro
num_experimentos = 10;
num_geracoes = 50;
numInd = 14; %numero de individuos a cada iteracao AG (populacao)

%% 1) INICIO A POPULACAO DE DICIONARIOS A PARTIR DO CONJUNTO DE TREINO
% vou cortar o espaço total em k populacoes (dicionarios) e rodar o ag k vezes
populacao = vit_inicia_populacao2(espaco_total,numInd,tam_code_book);

%for(exp = 1:num_experimentos)
   for ger = 1:num_geracoes

        %% 2) SELECIONO INDIVIDUOS PARA CRUZAR
        % fitness da minha primeira populacao
        d_pop_selec = vit_avalia_populacao2(populacao, espaco_total);
         % depois eu vou ordenar os valores do min p max
        [d_pop_ord_selec, populacao_ord_selec] = vit_ordena_pop(d_pop_selec, populacao);
        % agora eu vou rodar a roleta em cima dos valores normalizados.
        populacao_rol = vit_roleta(d_pop_ord_selec, populacao_ord_selec); 

        %% 3) CODIFICO PARA BINARIO
        % converte para um valor real que equivale a um valor binario de 16 bits
        [x_q,populacao_rol_bin]=vit_converte_bin2(populacao_rol,delta,b);
      
        %% 4) CRUZAMENTO
        Tcruzamento = 0.75; % 
        populacao_rol_bin_c = vit_cross_over2(populacao_rol_bin,Tcruzamento);

        %% 5) MUTACAO
        Tmutacao = 0.01;
        populacao_rol_bin_cm =vit_mutation(populacao_rol_bin_c,delta,Tmutacao);

        %% 6) CONVERTE PARA REAL
        populacao_rol_cm = vit_converte_real2(populacao_rol_bin_cm, b ,delta); %ta ok

        %% 7) AVALIO  A POPULACAO
        populacao = [ populacao_rol_cm; populacao]; %junto pais e filhos
        d_pop = vit_avalia_populacao2(populacao, espaco_total);

        %% 8) ORDENO A POPULACAO CONFORME OS VALORES MENORES 
        [d_pop_ord, populacao_ord] = vit_ordena_pop(d_pop, populacao);

        %% 9) SELECIONO OS MELHORES INDIVIDUOS PARA A PROXIMA GERACAO
        populacao = vit_elistimo( populacao_ord,numInd );
end
 d_pop = vit_avalia_populacao2(populacao, espaco_total)
 plot(d_pop,'rx');