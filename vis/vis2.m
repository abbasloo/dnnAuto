
d=load('/home/mabbasloo/Documents/carData3/data/lbo/f001_S2000001_1.mat');
dd=load('/home/mabbasloo/Documents/carData3/data/geovec/f001_S2000001_1.mat');
s=loadoff('/home/mabbasloo/Documents/carData3/f001_S2000001_1.off');
figure; clf; show_shape(s, d.Phi(:, 15));
figure; clf; show_shape(s, dd.desc(:, 15));