clc;
clear all;
shape = loadoff('/home/mabbasloo/Documents/carData2/f005_S2000001_30.off');
shape.idxs = compute_vertex_face_ring(shape.TRIV');
[desc, shape] = signature(shape, 'sihks');

l = load('/home/mabbasloo/Documents/carData2/dumps2/f005_S2000001_30.mat');
l = l.desc;
indx = zeros(1714, 1);
diff = zeros(1714, 1);
for i=1:1714
    [dummy, id] = max(l(:, i));
    indx(i) = id; 
    if id == i
        diff(i) = 0;
    else
       diff(i) = 1; 
    end
end
figure; clf; show_shape(shape, 1:1714); title('ground truth, t=30');
figure; clf; show_shape(shape, indx); title('ShapeNet, t=30');
figure; clf; show_shape(shape, diff); title('difference, t=30');