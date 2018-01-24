function[populacao_ord_r_bin_c] =vit_cross_over(populacao_ord_r_bin,numInd,Tcruzamento)
numInd = ceil(numInd/2)
[l, c] = size(populacao_ord_r_bin);
tam_dic = (l /numInd);
dics =ones(numInd, tam_dic,c);
whos dics
%% minha tarefa eh encher dics OK
for(i = 1:numInd)
   
   dics(i,1:tam_dic,:) =  populacao_ord_r_bin( ((i-1)*tam_dic) + 1: (tam_dic* i)  , :);
        
  
end
    


dics(1,:,:)





whos dics


%%

ponto = size(pop_rx_bin,2);
linhas = size(pop_rx_bin,1);

for (v = 1:linhas)
    for (lin = 1:(ponto-1))
        Decide_cruzar = rand(1);

        if (Decide_cruzar  < Tcruzamento)   
               aux = pop_rx_bin(v,(lin+1):end);
               pop_rx_bin(v,lin+1:end) = pop_ry_bin(v,(lin+1):end);
               pop_ry_bin(v,(lin+1):end) = aux;
        end
    end
end

pop_rx_bin_c = pop_rx_bin;
pop_ry_bin_c = pop_ry_bin;

end

