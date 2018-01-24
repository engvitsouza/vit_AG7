function [p2] = seleciona_pais(p1, f_p1, nRing)

[~,~,n] = size(p1);
p2 = zeros(size(p1));
idx = zeros(1, nRing);

for i = 1 : n
    for j = 1 : nRing
        idx(j) = randi(n);
    end
    valor = min(f_p1(idx));
    w = find(f_p1 == valor,1); %usa 1 para garantir w nao ser um vetor
    p2(:,:,i) = p1(:,:,w);  
end


end