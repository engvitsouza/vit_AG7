function populacao_rol_bin_c = vit_cross_over2(populacao_rol_bin,Tcruzamento)
% essa funcao cruza cada dic com um outro aleatorio
% ele soh nao pode cruzar com ele mesmo
[~, ~,numInd]=size(populacao_rol_bin);
populacao_rol_bin_c = populacao_rol_bin; %inicializa com atual populacao

for i=1:numInd
    Decide_cruzar = rand(1);
    if (Decide_cruzar  < Tcruzamento)
        %o i-esimo individuo vai ser substituido pelo cruzamento dele
        %com outro individuo, selecionado aleatoriamente. Tem que
        %garantir q ele nao cruza consigo mesmo
        selecioneiIndi = 0;
        while selecioneiIndi == 0
            pai = randi(numInd,1);
            if  pai ~= i
                selecioneiIndi = 1;
            end
        end
        %cruza i com parceiro selecionado acima
        pontoDeQuebra=randi([2 numInd-1],1);
        %atualiza o i-esimo individuo (um dicionario inteiro
        % o dic i vai ganhar um pedaco do  dic pai
        populacao_rol_bin_c(pontoDeQuebra:end,:,i) = populacao_rol_bin(pontoDeQuebra:end,:,pai);
    end
end
end