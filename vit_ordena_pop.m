function[d_pop, populacao] = vit_ordena_pop(d_pop, populacao)
% populacao ja tem as aptidoes  no d_pop
%  populacao  14x8x2     14 dicionarios         
%  d_pop      1x14       14 distancias dos dics
[numIndividuos,tam_codebook,K]=size(populacao);
for(j = 1: numIndividuos-1)
    % vai implementar as trocas entre dics
    for(i =1 : numIndividuos -1)
        var = d_pop(i);
        if(d_pop(i) > d_pop(i+1))
            d_pop(i) = d_pop(i+1);              % ordeno as distancias
            populacao(i,:,:) = populacao(i+1,:,:); % ordeno os dics
            d_pop(i+1) = var ;
        end
    end  
end
end
