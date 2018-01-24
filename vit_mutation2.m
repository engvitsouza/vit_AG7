function p2 =vit_mutation2(p,desvio,Tmutacao)

p2 = zeros(size(p)); % inicializo a pop
[a, b, numInd]=size(p);

for i = 1:numInd
    for j = 1:a
   
        if(rand < Tmutacao)
            p2(j,:,i) = p(j,:,i) + (desvio * randn(1,b));
        else
            p2(j,:,i) = p(j,:,i);
        end
  
    end
end



end