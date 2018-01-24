function [d_pop, novaPopulacao]= vit_avalia_populacaoEOtimizaLocalmenteComKmeans(populacao, espaco_total)
% function[d_pop, novoDicionario]= vit_avalia_populacaoEOtimizaLocalmenteComKmeans(populacao, espaco_total) 
%Usa o erro quadratico como distancia.
%Esta funcao usa o proprio kmeans como otimizacao baseada no conhecimento
%(local)
[~,K,numIndividuos]=size(populacao);
[~,K2]=size(espaco_total);
d_pop=zeros(1,numIndividuos); %guarda o fitness de cada individuo
if K~=K2
    error('As dimensoes da populacao e conjunto de treino nao coincidem!')
end
% para cada ponto (dicionario) i
% vou achar a distancia dele com um ponto j
novaPopulacao=zeros(size(populacao)); %alocar espaco
for i=1:numIndividuos
    dicionario=populacao(:,:,i);   %extrai o dicionario i
    [numVetoresCodebook,~]=size(dicionario); 
    dicionario=squeeze(dicionario);%elimina terceira dimensao i, desnecessaria
    %melhora usando K-means (tambem chamado algoritmo de Lloyd)
    %usa numero relativamente pequeno de iteracoes maxima (MaxIter)
    warning('off','all')
    [~,novoDicionario] = kmeans(espaco_total,numVetoresCodebook,...
        'start',dicionario,'MaxIter',30);
    warning('on','all')
    [distancias,~] = ...
        vit_codificaConjuntoDeVetores(espaco_total, dicionario); % as distancias do dic com espaco total
    novaPopulacao(:,:,i)=novoDicionario;
    d_pop(i) = mean(distancias);   % distorcao media 
end