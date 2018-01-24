function populacao = vit_inicia_populacao2(espaco_total,tam_pop,tam_code_book)
%function populacao = vit_inicia_populacao2(espaco_total,tam_pop,tam_code_book)
%Inicia dicionarios buscando aleatoriamente vetores do conjunto de treino.

[N,K]=size(espaco_total);

%populacao=zeros(tam_pop,tam_code_book,K); versao antiga




for i=1:tam_pop
    for j=1:tam_code_book
        randomIndex = floor(rand*N)+1;
        %fico sorteando para cada pedaco de quadrado com linhas 
        % do espaco total, assim vou montando 14 dicionarios
        populacao(i,j,:)=espaco_total(randomIndex,:);
        % a populacao sao 14 dicionarios, 14 quadrados 8 x 2
     end
end

   % guarda os 14 dicionarios     