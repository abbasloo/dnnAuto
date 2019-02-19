function extract_labels(srcpath, dstpath, dim)

fnames = dir(fullfile(srcpath, '*.off'));
parfor i = 1 : length(fnames)
    fprintf('Processing %s\n', fnames(i).name)
    namesplit = strsplit(fnames(i).name, '.');
    name = strcat(namesplit{1}, '.mat');
    labels = 1:dim;
    parsave(fullfile(dstpath, name), labels');
end
end

function parsave(fn, labels)
save(fn, 'labels', '-v7.3')
end