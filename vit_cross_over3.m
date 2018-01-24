function p3 = vit_cross_over3(p,Tcruzamento)
% essa funcao cruza cada dic com um outro aleatorio 
% ele soh nao pode cruzar com ele mesmo
[ nLines, ~,n]=size(p);
p3 = zeros(size(p)); %inicializa com atual populacao

for i = 1:2:n
  pai1 = p(:,:,i);
  pai2 = p(:,:,i+1);
  if (rand < Tcruzamento)
    cutPoint = randi(nLines-1);
    
    p3(:,:,i) = [pai1(1:cutPoint,:); pai2(cutPoint+1:end, :)]; %montei um ind = quadrado
    p3(:,:,i+1) = [pai1(cutPoint+1:end, :); pai2(1:cutPoint, :)];
  else
      p3(:,:,i) = pai1;
      p3(:,:,i+1) = pai2;
  end
  
end
