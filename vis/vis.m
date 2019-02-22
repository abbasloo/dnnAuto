clc;
clear all;
shape = loadoff('/home/mabbasloo/Documents/carData2/f005_S2000001_30.off');
shape.idxs = compute_vertex_face_ring(shape.TRIV');
[desc, shape] = signature(shape, 'sihks');

l = load('/home/mabbasloo/Documents/carData2/dumps2/f005_S2000001_30.mat');
l = l.desc;
indx = zeros(1714, 1);
diff = zeros(1714, 1);
diff2 = zeros(1714, 1);
for i=1:1714
    X = shape.X; Y = shape.Y; Z = shape.Z;
    %X(i) = []; Y(i) = []; Z(i) = []; 
    ReferencePts = [X, Y, Z];
    [tmp, tmp, TreeRoot] = kdtree( ReferencePts, []);
    TestPoints = [shape.X(i), shape.Y(i), shape.Z(i)];
    %[ ClosestPts, DistA, TreeRoot ] = kdtree([], TestPoints, TreeRoot);
    %[ ClosestPtIndex, DistB, TreeRoot ] = kdtreeidx([], TestPoints, TreeRoot);
    [ ClosestPts, Dist , ClosestPtIndex] = kdrangequery( TreeRoot, TestPoints, 25.0 );
    [dummy, id] = max(l(:, i));
    indx(i) = id; 
    if id == i
        diff(i) = 0;
    else
       diff(i) = 1; 
    end
    L = size(ClosestPtIndex);
    for j=1:L(1)
        if id == ClosestPtIndex(j)
            diff2(i) = 0;
            break;
        else
            diff2(i) = 1; 
        end 
    end
end
figure; clf; show_shape(shape, 1:1714); title('ground truth, t=30');
figure; clf; show_shape(shape, indx); title('ShapeNet, t=30');
figure; clf; show_shape(shape, diff); title('difference, t=30');
figure; clf; show_shape(shape, diff2); title('nearest neighbors difference, t=30');
%figure; clf; scatter3(shape.X,shape.Y,shape.Z, '.'); title('point cloud, t=30');