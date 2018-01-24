N=[16 256 1024 4096];
EVM=[30.6346 8.1618 4.5097 2.484];
K=2; %amostras por vetor
bitsPerSample=log2(N)/K;
plot(bitsPerSample,EVM)
xlabel('bits por amostra real')
ylabel('EVM (%)')
grid