function extract_patch_operator(srcpath, dstpath, patch_params, dim)

if ~exist(dstpath, 'dir')
    mkdir(dstpath);
end

fnames = dir(fullfile(srcpath, '*.off'));
parfor i = 1 : length(fnames)
    if exist(fullfile(dstpath, fnames(i).name), 'file')
        fprintf('%s already processed, skipping\n', fnames(i).name)
        continue
    end
    fprintf('Processing %s\n', fnames(i).name)
    %tmp = load(fullfile(srcpath, fnames(i).name));
    tmp = struct;
    tmp.shape = loadoff(fullfile(srcpath, fnames(i).name));
    shape = tmp.shape;
    
    [M, ~] = compute_extraction(shape, patch_params);
    % make a big matrix out of all the various M_i
    % each matrix in the cell array is stacked row after row.
    % this allows a more efficient moltiplication and handling in theano
    M = sparse(cat(1, M{:}));
    namesplit = strsplit(fnames(i).name, '.');
    name = strcat(namesplit{1}, '.mat');
    dim3 = patch_params.nbinsr*patch_params.nbinsth*dim;
    parsave(fullfile(dstpath, name), M(1:dim3, 1:dim));
end
end

function parsave(fn, M)
save(fn, 'M', '-v7.3')
end
