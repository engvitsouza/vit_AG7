close all
rgb = imread('gato.png');
gray = rgb2gray(rgb);
gray= medfilt2(gray);

[Gmag,Gdir] = imgradient(gray);

figure, imshow(Gmag, []), title('Gradient magnitude')

A=accumarray(subs, Gmag);