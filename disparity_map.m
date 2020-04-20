function [D, R,  T] = disparity_map(scene_path)
addpath(scene_path);
im0= imread('im0.png');
im1= imread('im1.png');
file = strcat(scene_path,'/calib.txt');
copyfile(file, 'calib.m');
calib;
delete('calib.m');
img0 = rgb_to_gray(im0);
img1 = rgb_to_gray(im1);
m0 = harris_detektor(img0, 'segment_length', 9, 'k', 0.06, 'do_plot', true);
m1 = harris_detektor(img1, 'segment_length', 9, 'k', 0.06, 'do_plot', true);
Korrespondenzen = punkt_korrespondenzen(img0,img1,m0,m1,'window_length',25,'min_corr', 0,'do_plot',false);
[EF] = achtpunktalgorithmus(Korrespondenzen) ;
E=cam1'*EF*cam0;
[T1, R1, T2, R2, U, V]=TR_aus_E(E)
[R T] = R_T_calculate(T1, T2, R1, R2, Korrespondenzen);

D=disparity(im0,im1,30);
D=uint8(D);
rmpath(scene_path);
end