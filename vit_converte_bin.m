function[populacao_ord_r_bin] = vit_converte_bin(populacao_ord_r)

[numIndividuos,tam_codebook,K]=size(populacao_ord_r);
t = numIndividuos*tam_codebook*K;

populacao_ord_r_bin = zeros(t,1);

for(i = 1:numIndividuos)
    for(j = 1:tam_codebook)
        for (k = 1: K)
            count = 1;
            populacao_ord_r_bin(count,1) = populacao_ord_r(i,j,k);
            count = count +1; 
        end
    end
end
      
populacao_ord_r_bin = dec2bin(2^27 *(populacao_ord_r_bin +10 )); % multipliquei por 2^27 para que desse 32 bits

end