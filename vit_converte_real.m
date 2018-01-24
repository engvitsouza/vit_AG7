function [populacao_ord_r] = vit_converte_real(populacao_ord_r_bin)
populacao_ord_r  = (   bin2dec(populacao_ord_r_bin) /2^4  ) -10;
end