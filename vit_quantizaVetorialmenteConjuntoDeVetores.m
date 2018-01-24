function vetoresQuantizados = ...
    vit_quantizaVetorialmenteConjuntoDeVetores(vetores, dicionario)

vetoresQuantizados=zeros(size(vetores));

[tam_codebook,K]=size(dicionario);
[blockSize,numberOfBlocks]=size(vetores);
numVetoresPorBloco = blockSize/K;
if numVetoresPorBloco ~= floor(numVetoresPorBloco)
    error('O tamanho do bloco precisa ser multiplo da dimensao dos vetores do dicionario!')
end
for i=1:numberOfBlocks
    for k=0:numVetoresPorBloco-1
        inicio=k*K+1;
        fim=inicio+K-1;
        vetor=transpose(vetores(inicio:fim,i));
        distanciaMinima = Inf; %usar grande numero
        indiceMelhorCodeword = -1; %inicializa
        for j=1:tam_codebook
            erro=vetor-dicionario(j,:); % calcula erro            
            erroQuadratico=sum(erro.^2);
            if erroQuadratico < distanciaMinima
                indiceMelhorCodeword = j;
                distanciaMinima = erroQuadratico; %guarda soh o melhor
            end
        end
        vetoresQuantizados(inicio:fim,i)=transpose(dicionario(indiceMelhorCodeword,:));
    end
end
