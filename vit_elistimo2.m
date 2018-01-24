function [p9, f_p9] = vit_elistimo2(p1, f_p1, p4, f_p4)
   p = cat(3,p1,p4);
   f_p = [f_p1 f_p4];
   
   [~,idx] = sort(f_p);
   w = length(f_p)/2;
   
   %bug:
   %p1 = p(:,:,idx(1:w));
   %f_p1 = f_p(1:w);

   p9 = p(:,:,idx(1:w));
   f_p9 = f_p(idx(1:w));   
end
