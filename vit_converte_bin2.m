function [x_q,x_i]=vit_converte_bin2(x,delta,b)
% function [x_q,x_i]=vit_converte_bin2(x,delta,b)
%This function assumes the quantizer allocates 2^(b-1) levels to
%negative output values, one level to the "zero" and 2^(b-1)-1 to 
%positive values. The it converts this range to 0 to (2^b)-1 such
%that all indices are positive.
x_i = x / delta; %quantizer levels

x_i = round(x_i); %nearest integer
x_i(x_i > 2^(b-1) - 1) = 2^(b-1) - 1; %impose maximum 
x_i(x_i < -2^(b-1)) = -2^(b-1); %impose minimum
x_q = x_i * delta;  %quantized output
x_i = x_i + 2^(b-1); %encoded output, with only positive indices
