function vit_plotaPopulacao(populacao)
% function vit_plotaPopulacao(populacao)
%Plota todos dicionarios em uma populacao AG

[N,K,numIndividuos]=size(populacao);
if K~=2
    error('Essa funcao funciona so quando a dimensao = 2')
end
hold on
mycolors=['b','r','k','g','y','m','c']; %usa cores diferentes
numColors=length(mycolors);
for i=1:numIndividuos
    dicionario=populacao(:,:,i);
    dicionario=squeeze(dicionario); %elimina terceira dimensao, desnecessaria
    %poderia usar diferente cor para cada individuo, fazendo uso de
    %https://www.mathworks.com/matlabcentral/answers/119852-plotting-many-plots-on-same-figure-with-unique-colors
    thisColor=mod(i-1,numColors)+1;
    plot(dicionario(:,1),dicionario(:,2),['o' mycolors(thisColor)]); %assume K=2
    %pause
end
hold off