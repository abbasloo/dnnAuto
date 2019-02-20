%close all;
clc;
clear;
rootdir = fileparts(mfilename('fullpath'));
addpath(fullfile(rootdir, 'util'));
addpath(fullfile(rootdir, 'sihks'));

shape = loadoff('/home/mabbasloo/Documents/carData/f010_S2000001_60.off');
%load(fullfile(rootdir, 'shapes', '0001.scale.1.mat'), 'shape');

%% SIHKS signature

fprintf('preprocessing');
shape.idxs = compute_vertex_face_ring(shape.TRIV');
%ndesc = 10;
[desc, shape] = signature(shape, 'sihks');
fprintf('.\n');

%% ISC settings

rad = 40;   % radius used for descriptor construction
nbinsr = 4;   % number of rings
nbinsth = 8;   % number of rays

rr = [1:nbinsr]/nbinsr*rad;
th = [1:nbinsth]/nbinsth*2*pi;

fhs = 2.0;     % factor determining hardness of scale quantization
fha = 0.01;       % factors determining hardness of angle quantization

shape.f_dns = fastmarchmex('init', int32(shape.TRIV-1), double(shape.X(:)), double(shape.Y(:)), double(shape.Z(:)));

%[~, vertex] = max(shape.Z);
vertex = 900;
shape = fast_marching(vertex, shape, 'vertex', 0, 1, shape.f_dns);
[in_ray, in_ring, shp, geod, directions, ds] = get_net(shape, vertex, 'scales', [0, rr], 'N_rays', length(th), 'fhs', fhs, 'fha', fha);

shape.Av = full(diag(shape.A));

[desc_net, M] = get_descriptor_from_net(in_ray, in_ring, desc, shape.Av); 

dind = 15;
tmp = reshape(M * desc(:, dind), nbinsr, nbinsth);
%desc_net(1, :, :) = tmp;

fastmarchmex('deinit', shape.f_dns);

%% end of code, visualization of results 

figure; clf; show_shape(shape, desc(:, dind));
hold on; scatter3(geod{1}(1, 1), geod{1}(2, 1), geod{1}(3, 1), 'filled', 'SizeData', 100, 'Cdata', [1, 0, 0]);
for k = [1:length(geod)]
    hold on;
    h = plot3(geod{k}(1, :), geod{k}(2, :), geod{k}(3, :));
    set(h,'Color', [0 0 0], 'LineWidth', 1);
end
for r = [1:length(rr)]
    plot_ring(shape, rr(r));
end
%title('Net around vertex');
view(-140, 29);

figure; clf; plot_polarhist(squeeze(desc_net(dind, :, :)), rr, th, 0); axis off;
