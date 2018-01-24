%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc 
clear
close all
format long;    
ShowPlots = 1;
%tic
mu = [2,3];
sigma = [1,1.5;1.5,3];
% para que o espaco de busca seja sempre o mesmo
rng default  
espaco_total = mvnrnd(mu,sigma,1000);

%if(ShowPlots == 1)
%    figure
%    plot(espaco_total(:,1),espaco_total(:,2),'bo');
%    title('All points');
%end

%maximo e minimo para codificacao binaria. Assume que a faixa
%dinamica dos numeros eh de -xmax a xmax
xmax=max(abs(espaco_total(:))); %valor de pico, absoluto
b=16; %numero de bits para codificacao binaria
delta=abs((2*xmax)/((2^b)-1)); %quantization step

% numero de centros que procuro
tam_code_book = 8;

% numero de vezes que populacao inicial vai rodar 
% como eh um algoritmo de busca pseudo aleatorio
% uma mesma pop pode levar a diversas respostas...
% logo vou testar a mesma pop varias vezes
num_experimentos = 10;

% quantas vezes um conjunto de individuos vai evoluir
num_geracoes = 2;

%numero de individuos a cada iteracao AG (populacao)
numInd = 14; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ALGORITMO DE OTIMIZAÇÃO DE CODEBOOK 
%% 1) INICIO A POPULACAO DE DICIONARIOS A PARTIR DO CONJUNTO DE TREINO
% vou cortar o espaço total em k populacoes (dicionarios) e rodar o ag k vezes
populacao = vit_inicia_populacao2(espaco_total,numInd,tam_code_book);
%vit_plotaPopulacao(populacao) %para visualizar a populacao, se quiser

%% TODO : resolver esses experimentos e geracoes e plotar o comp medio
%for(exp = 1:num_experimentos)
   for(ger = 1:num_geracoes)

    %% 2) SELECIONO INDIVIDUOS PARA CRUZAR
    % primeiro eu vou calcular o fitness da minha primeira populacao
    d_pop_selec = vit_avalia_populacao2(populacao, espaco_total);

    figure
    plot(d_pop_selec,'xr');
    title('Fitness Inicial');
    % depois eu vou ordenar os valores do min p max
    [d_pop_ord_selec, populacao_ord_selec] = vit_ordena_pop(d_pop_selec, populacao);

    % agora eu vou rodar a roleta em cima dos valores normalizados.
    populacao_rol = vit_roleta(d_pop_ord_selec, populacao_ord_selec);
    %if(ShowPlots == 1)
    %    figure 
    %    plot(espaco_total_x,espaco_total_y,'Bo'); hold on
    %    plot(pop_rx, pop_ry,'xr','MarkerSize',20 );hold off
    %    title('First Codebook Using Roulete');  %%% podemos concluir que deu merda       
    %end

    %% 3) CODIFICO PARA BINARIO
    % converte para um valor real que equivale a um valor binario de 16 bits
    % para facilitar a manipulacao
    [x_q,populacao_rol_bin]=vit_converte_bin2(populacao_rol,delta,b);
    %caso queira verificar se os valores sao decodificados corretamente:
    %x_q2 = vit_converte_real2(populacao_ord_r_bin,b,delta);

    %% 4) CRUZAMENTO
    % busca acelerador do processo de busca
    %tirando proveito das soluções mais promissoras
    % essa minha rotina so faz cruzamento em um ponto, poderia ter outros tipos
    Tcruzamento = 0.75; % tem algo 
    %[populacao_ord_r_bin_c] =vit_cross_over2(populacao_ord_r_bin,numInd,Tcruzamento);
    populacao_rol_bin_c = vit_cross_over2(populacao_rol_bin,Tcruzamento);

    %% 5) MUTACAO
    % operador exploratório
    % dispersa a população pelo espaço de busca para tentar evitar a
    % convergencia prematura  que pode achar minimos locais
    Tmutacao = 0.01;
    populacao_rol_bin_cm =vit_mutation(populacao_rol_bin_c,delta,Tmutacao);

    %% 6) CONVERTE PARA REAL
    populacao_rol_cm = vit_converte_real2(populacao_rol_bin_cm, b ,delta); %ta ok

    %if(ShowPlots == 1)
    %   figure 
    %   plot(espaco_total(:,1),espaco_total(:,2),'bo');
    %   vit_plotaPopulacao(populacao_ord_r2) %para visualizar a populacao, se quiser  
    %   plot(pop_rx_cm,pop_ry_cm,'xr','MarkerSize',20 );
    %   title(' Codebook After GA'); hold off ;      
    %end

    %end
    %end

    %% 7) AVALIO  A POPULACAO

    populacao = [ populacao_rol_cm; populacao]; %junto pais e filhos

    %d_pop e o fitness de cada individuo (dicionario) como sendo a distorcao
    %media de todo o conjunto de treino quantizador 
    d_pop = vit_avalia_populacao2(populacao, espaco_total);

    %if(ShowPlots == 1)
    %    figure 
    %    plot(d_pop,'rx'); 
    %    title('First fitness values');% quando eu descomento o vit_Plota...ai esse funciona kkk
    %end

    %% 8) ORDENO A POPULACAO CONFORME OS VALORES MENORES !!!! ESSE EH UM PROBLEMA DE MINIMO!!!!!
    [d_pop_ord, populacao_ord] = vit_ordena_pop(d_pop, populacao);
    %vit_plotaPopulacao(populacao_ord) %para visualizar a populacao, se quiser  

    %if(ShowPlots == 1)
    %    figure  
    %    plot(d_pop_ord,'rx');
    %    title('Distances Ordered');
    %end

    %% 9) SELECIONO SOMENTE OS MELHORES INDIVIDUOS PARA A PROXIMA GERACAO
    populacao = vit_elistimo( populacao_ord,numInd );
    [d_pop_neeew]= vit_avalia_populacao2(populacao, espaco_total);
   end

    figure
    plot(d_pop_neeew,'xr');
    title('Fitness Final');