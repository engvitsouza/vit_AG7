function p2 =vit_mutation3(p,desvio,Tmutacao)
% function p2 =vit_mutation3(p,desvio,Tmutacao)
%Essa função multiplica o mesmo desvio randomico por todas dimensoes
p2 = p; % inicializo a pop
[N, K, numInd]=size(p);
for i = 1:numInd
    for j = 1:N   %para todos vetores
        if(rand < Tmutacao)
            fatorDeEscala = desvio * randn;
            p2(j,:,i) = p(j,:,i) * fatorDeEscala;
        end
    end
end
end