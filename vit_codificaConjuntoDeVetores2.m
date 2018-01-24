function [distancias,indicesEscolhidos,novoDicionario] = ...
    vit_codificaConjuntoDeVetores2(vetores, dicionario)
%Essa funcao nao apenas codifica mas tambem gera uma nova populacao

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

%gera novo dicionario tirando media aritmetica para cada "particao"
novoDicionario = zeros(size(dicionario)); %pre-aloca espaco
numVetoresAssociados = zeros(1,tam_codebook);
for i=1:numVetoresDeTreino
    novoDicionario(indicesEscolhidos(i),:) = novoDicionario(indicesEscolhidos(i),:) + vetores(i,:);
    numVetoresAssociados(indicesEscolhidos(i)) = numVetoresAssociados(indicesEscolhidos(i)) + 1;
end
for i=1:tam_codebook
    if numVetoresAssociados(i) == 0
        maisPopularIndice=find(numVetoresAssociados==max(numVetoresAssociados),1);
        novoDicionario(i,:)=dicionario(maisPopularIndice,:).* (0.0001*randn(1,K));
    else
        indicesEscolhidos(i) = indiceMelhorCodeword;
    end
end
