clc;
clear;
%rng(42, 'twister')
addpath(genpath('isc'))
dim = 1714;

%% Compute LBO
nLBO = 200;
extract_lbo('/home/mabbasloo/Documents/carData/', '/home/mabbasloo/Documents/carData/data/lbo', nLBO);

%% Compute GEOVEC
nGEOVEC = 100;
geovec_params = estimate_geovec_params('/home/mabbasloo/Documents/carData/data/lbo', nGEOVEC);
extract_geovec('/home/mabbasloo/Documents/carData/data/lbo', '/home/mabbasloo/Documents/carData/data/geovec', geovec_params, dim);

%% Compute patch operator (disk)
patch_params.rad          = 40;    % disk radius
patch_params.flag_dist    = 'fmm';   % possible choices: 'fmm' or 'min'
patch_params.nbinsr       = 4;       % number of rings
patch_params.nbinsth      = 8;      % number of rays
patch_params.fhs          = 2.0;     % factor determining hardness of scale quantization
patch_params.fha          = 0.01;    % factor determining hardness of angle quantization
patch_params.geod_th      = false;
extract_patch_operator('/home/mabbasloo/Documents/carData/', '/home/mabbasloo/Documents/carData/data/disk', patch_params, dim);

%% Compute labels
extract_labels('/home/mabbasloo/Documents/carData/', '/home/mabbasloo/Documents/carData/data/labels', dim);
