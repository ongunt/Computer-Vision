function [Fx, Fy] = sobel_xy(input_image)
 
Fx=conv2([1  2 1],[1 0 -1],input_image,'same');
Fy=conv2([1 0 -1],[1  2 1],input_image,'same');
end