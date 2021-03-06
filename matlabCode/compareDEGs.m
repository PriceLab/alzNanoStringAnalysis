
% some simple calculations to compare distribution of differentially
% expressed genes between TG and nTG mice

load('AD_NSNorm_data.mat')

degStruct = degAllComps(X,Y,accessions);

%% Compare proportion of significant differentially expressed genes

% get q-values for IL-10 vs. CTRL in Tg mice
TgQvals = cellfun(@str2num, degStruct(1).results(:,4));

% get q-values for IL-10 vs. CTRL in nTg mice
nTgQvals = cellfun(@str2num, degStruct(13).results(:,4));

% find number of significant DEGs in Tg mice
TgNumSig = sum(TgQvals < 0.05);

% find number of significant DEGs in nTG mice
nTgNumSig = sum(nTgQvals < 0.05);

% note: Z-test for comparing 2 population proportions performed
% online at http://vassarstats.net/propdiff_ind.html with values
% k_a = 140 (TgNumSig)
% n_a = 241 (total genes)
% k_b = 47 (nTgNumSig)
% n_b = 241 (total genes)
%
% Z-score = 8.693, two-tail p-value < 0.0002

%% Compare relative magnitude of modulation among common DEGs

% get log ratios for IL-10 vs. CTRL in Tg mice
TgLogRatio = cellfun(@str2num, degStruct(1).results(:,3));

% get log ratios for IL-10 vs. CTRL in nTg mice
nTgLogRatio = cellfun(@str2num, degStruct(13).results(:,3));

% switch the sign of log ratios (so that CTRL is baseline)
TgLogRatio = -1*TgLogRatio;
nTgLogRatio = -1*nTgLogRatio;

% find DEGs common to both mice strains
[commonDEGs,TgIdx,nTgIdx] = intersect(...
    degStruct(1).results(TgQvals < 0.05,1),...
    degStruct(13).results(nTgQvals < 0.05, 1));

commonLogRatDiffs = abs(TgLogRatio(TgIdx)) - abs(nTgLogRatio(nTgIdx));
TgNumGreater = sum(commonLogRatDiffs > 0);
nTgNumGreater = sum(commonLogRatDiffs < 0);

% note: Z-test for comparing 2 population proportions performed
% online at http://vassarstats.net/propdiff_ind.html with values
% k_a = 13 (TgNumGreater)
% n_a = 45 (num DEGs in common)
% k_b = 32 (nTgNumGreater)
% n_b = 45 (num DEGs in common)
%
% Z-score = -4.006, two-tail p-value < 0.0002 
%
% Z-score = 8.693, two-tail p-value < 0.0002