function x_q = vit_converte_real2(x_i,b,delta)
minimumValue = 2^(b-1); 
x_i = x_i - minimumValue; %convert minimum from 0 to original value
x_q = x_i * delta;  %de-quantized output
end