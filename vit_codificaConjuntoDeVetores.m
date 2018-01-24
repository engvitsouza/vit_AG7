function [distancias,indicesEscolhidos] = ...
    vit_codificaConjuntoDeVetores(vetores, dicionario)

[tam_codebook,K]=size(dicionario);
[numVetoresDeTreino,K2]=size(vetores);
if K~=K2
    error('As dimensoes do dicionario e conjunto de treino nao coincidem!')
end
distancias=zeros(1,numVetoresDeTreino); %distancias minimas
indicesEscolhidos=zeros(1,numVetoresDeTreino); %indices das codewords

for i=1:numVetoresDeTreino
    distanciaMinima = Inf; %usar grande numero
    indiceMelhorCodeword = -1; %inicializa
    for j=1:tam_codebook
        erro =vetores(i,:)-dicionario(j,:); % calcula erro
        
        erroQuadratico=sum(erro.^2);
        if erroQuadratico < distanciaMinima
            indiceMelhorCodeword = j;
            distanciaMinima = erroQuadratico; %guarda soh o melhor
        end
    end
   distancias(i) = distanciaMinima; % guarda as melhores
   indicesEscolhidos(i) = indiceMelhorCodeword;
end