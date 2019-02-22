function test(srcpath)
fnames = dir(fullfile(srcpath, '*.mat'));
parfor i = 1 : length(fnames)
    %fprintf('Processing %s\n', fnames(i).name)
    M = load(fullfile(srcpath, fnames(i).name));
    size (M.M)
end
end