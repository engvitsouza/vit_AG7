function populacao_rol_bin_cm =vit_mutation(populacao_rol_bin_c,delta,Tmutacao)

populacao_rol_bin_cm = populacao_rol_bin_c; % inicializo a pop
[numInd, a, b]=size(populacao_rol_bin_c);

for (i = 1:numInd)
       Decide_mutacao = rand(1); 
       if(Decide_mutacao < Tmutacao)

           populacao_rol_bin_cm(i,:,:) = populacao_rol_bin_c(i,:,:) + (sqrt(delta)*randn(1,a,b));
       end
  
     
end



end

