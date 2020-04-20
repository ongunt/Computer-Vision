
function psnr=calculate_psnr(A,B)
A = double(A); B =double(B);

d = sum((A(:)-B(:)).^2) / prod(size(A));
psnr = 10*log10(255*255/d);

end