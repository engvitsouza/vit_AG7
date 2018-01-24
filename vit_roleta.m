function[populacao_ord_r] = vit_roleta(d_pop_ord,populacao_ord)

d_pop_norm = (d_pop_ord./sum(d_pop_ord));
d_pop_norm = cumsum(d_pop_norm,'reverse');
d_pop_norm = fliplr(d_pop_norm);

[numIndividuos,tam_codebook,K]=size(populacao_ord);
populacao_ord_r = populacao_ord; % inicializo a pop

% sorteio um individuo
for i = 1: numIndividuos % vou preencher os v individuos
    a =  find (d_pop_norm > rand);% sorteio o dic
    aux = length(a);
    sorteia = a(aux); % seleciono o menor d_pop_norm que eh maior do q o rand
    populacao_ord_r(i,:,:) = populacao_ord(sorteia,:,:);% sorteio
  
end
