function[d_pop]= vit_avalia_populacao2(populacao, espaco_total)
% function[d_pop]= vit_avalia_populacao2(populacao, espaco_total)
%Usa o erro quadratico como distancia.
[numIndividuos,tam_codebook,K]=size(populacao);
[numVetoresDeTreino,K2]=size(espaco_total);
d_pop=zeros(1,numIndividuos); %guarda o fitness de cada individuo
if K~=K2
    error('As dimensoes da populacao e conjunto de treino nao coincidem!')
end
% para cada ponto (dicionario) i
% vou achar a distancia dele com um ponto j
for i=1:numIndividuos
    dicionario=populacao(i,:,:);   %extrai o dicionario i
    dicionario=squeeze(dicionario);%elimina terceira dimensao i, desnecessaria
    [distancias,indicesEscolhidos] = ...
        vit_codificaConjuntoDeVetores(espaco_total, dicionario); % as distancias do dic com espaco total
    d_pop(i) = mean(distancias);   % distorcao media 
end