prompt='name';
tic
scene_path = input(prompt,'s');
[D, R,  T] = disparity_map(scene_path);
addpath(scene_path);
G= readpfm('disp0.pfm');

rmpath(scene_path);
p=calculate_psnr(D,G);
elapsed_time = toc;
imagesc(D);

disp(strcat('Time: ',num2str(elapsed_time),' seconds.'));
