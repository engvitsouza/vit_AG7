function populacao = vit_inicia_populacao4(espaco_total,numInd,tam_code_book)
%function populacao = vit_inicia_populacao4(espaco_total,numInd,tam_code_book)
%Inicia dicionarios aleatoriamente ao inves de buscar vetores do conjunto de treino como na 3.
 
[N,K]=size(espaco_total);

maxValue=max(abs(espaco_total(:)));

populacao=maxValue*2*(rand(tam_code_book,K, numInd)-0.5);

%farei o primeiro dicionario da populacao ser o obtido por kmeans
%dai o elitismo fará que a AG nunca fique pior que o kmeans
%projeto usando K-means (tambem chamado algoritmo de Lloyd):
[~,dicionarioKmeans] = kmeans(espaco_total,tam_code_book);
populacao(:,:,1)=dicionarioKmeans;
