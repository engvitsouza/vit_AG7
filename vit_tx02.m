%Implementa   block scaling + VQ


sd   = reshape(signal(:),Ns,[]);
%  sd        32x9600            4915200  double    complex   

sd_i = real(sd);
%  sd_i      32x9600            2457600  double      
sd_q = imag(sd);
%  sd_q      32x9600            2457600  double  

sd_i_max = max(abs(sd_i));
sd_q_max = max(abs(sd_q));

A_k = max([sd_i_max ; sd_q_max]);
sd_i_max = A_k;
sd_q_max = A_k;
%TODO: quantize sd max

%Block scaling
sd_i_norm  = bsxfun(@rdivide,sd_i,sd_i_max);
sd_q_norm  = bsxfun(@rdivide,sd_q,sd_q_max);

if 1 
   sd_i_norm_quant = ...
       vit_quantizaVetorialmenteConjuntoDeVetores(sd_i_norm ,  dicionarioAG );
   sd_q_norm_quant = ... 
       vit_quantizaVetorialmenteConjuntoDeVetores(sd_q_norm ,  dicionarioAG );
    
end


%% Save files
%if (save_signals_in_a_file == 1)
%    %sinal quantizado
%    save_signal(sd_i_norm_quant(:),fn_signal_norm_values_real,'float');
%    save_signal(sd_q_norm_quant(:),fn_signal_norm_values_imag,'float');
%      
%end
