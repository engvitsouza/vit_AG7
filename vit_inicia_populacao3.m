function populacao = vit_inicia_populacao3(espaco_total,numInd,tam_code_book)
%function populacao = vit_inicia_populacao2(espaco_total,tam_pop,tam_code_book)
%Inicia dicionarios buscando aleatoriamente vetores do conjunto de treino.
 
[N,K]=size(espaco_total);

populacao=zeros(tam_code_book,K, numInd); % tam pop eh a ultima geracao


for i=1:numInd
    for j=1:tam_code_book
        randomIndex = floor(rand*N)+1;
        %fico sorteando para cada pedaco de quadrado com linhas 
        % do espaco total, assim vou montando 14 dicionarios
        populacao(j,:,i)=espaco_total(randomIndex,:);
        % a populacao sao 14 dicionarios, 14 quadrados 8 x 2
     end
end
% whos populacao
   % guarda os 14 dicionarios     