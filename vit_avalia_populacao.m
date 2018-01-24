function[d_pop]= vit_avalia_populacao( pop_x, pop_y, espaco_total_x,espaco_total_y)
% para cada ponto i 
% vou achar a distancia dele com um ponto j
d_pop = zeros(  length(espaco_total_x), length(pop_x)  );

for( l = 1:length(espaco_total_x))
    for( c= 1:length(pop_x))
                 d_pop(l,c) = sqrt( (pop_x(c) - espaco_total_x(l))^2  + (pop_y(c) - espaco_total_y(l) )^2 );
    end 
end
d_pop = sum(d_pop);
end
