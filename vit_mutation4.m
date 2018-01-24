function p2 =vit_mutation4(p,desvio,Tmutacao)
%function p2 =vit_mutation4(p,desvio,Tmutacao)
%Essa função multiplica um mesmo desvio randomico em todos vetores de um
%dicionario
p2 = p; % inicializo a pop
[N, K, numInd]=size(p);
for i = 1:numInd
    if(rand < Tmutacao)
        fatorDeEscala = desvio * randn; %mesmo fator para todos vetores
        p2(:,:,i) = p(:,:,i) * fatorDeEscala;
    end
end
end