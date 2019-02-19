function extract_lbo(srcpath, dstpath, nLBO)

fnames = dir(fullfile(srcpath, '*.off'));
parfor i = 1 : length(fnames)
    fprintf('Processing %s\n', fnames(i).name)
    %tmp = load(fullfile(srcpath, fnames(i).name));
    tmp = struct;
    tmp.shape = loadoff(fullfile(srcpath, fnames(i).name));
    [Phi, Lambda, A] = calc_lbo(tmp.shape, nLBO);
    namesplit = strsplit(fnames(i).name, '.');
    name = strcat(namesplit{1}, '.mat');
    parsave(fullfile(dstpath, name), Phi, Lambda, A);
end
end

function parsave(fn, Phi, Lambda, A)
save(fn, 'Phi', 'Lambda', 'A', '-v7.3')
end