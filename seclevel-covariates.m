% This script runs a 6x2 multifactorial design for second level analysis (main effect of DiMartino's striatal seeds)

clc

%==========================================================================
% Directories
%==========================================================================
datadir = '/projects/kg98/kristina/GenofCog/datadir/derivatives/'
firstlevel_dir = ['/firstlevel/DiMartino+GSR/'];
outdir = [datadir,'secondlevel/DiMartino+GSR/FactorScores/']

% make outdir
if exist(outdir) == 0
    fprintf(1,'Initialising outdir\n')
    mkdir(outdir)
elseif exist(outdir) == 7
    fprintf(1,'Output directory already exists\n')
end

% ------------------------------------------------------------------------------
% Load in non imaging data
% ------------------------------------------------------------------------------
cd(workdir)
load('SzFactorScores.mat')

% ------------------------------------------------------------------------------
% Count number of subjects (subs variable in matlab)
% ------------------------------------------------------------------------------
% number of subjects
numSubs = length(subs)


% ------------------------------------------------------------------------------
% Select ROI
% ------------------------------------------------------------------------------
ROInum = 3; 

if ROInum == 1
    ROIname = 'VSi'
elseif ROInum == 2
    ROIname = 'VSs'
elseif ROInum == 3
    ROIname = 'DC'
elseif ROInum == 4
    ROIname = 'DCP'
elseif ROInum == 5
    ROIname = 'DRP'
elseif ROInum == 6
    ROIname = 'VRP'
end

conImage = ['con_000',num2str(ROInum),'.img'];

% ------------------------------------------------------------------------------        
% Define covariates
% ------------------------------------------------------------------------------        

Cov_names = {'SchizG','SchizNeg','SchizPos'};
numCov = length(Cov_names);

% ------------------------------------------------------------------------------
% Load SPM
% ------------------------------------------------------------------------------
spmdir = '/usr/local/spm8/matlab2015b.r6685/';
addpath(spmdir)

spm

%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {outdir};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).name = 'hemi';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).ancova = 0;

matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).levels = 1;
for i = 1:numSubs
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).scans{i} = [datadir,subs{i},firstlevel_dir,'left_hemi/',conImage];
end

matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).levels = 2;

for i = 1:numSubs
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).scans{i} = [datadir,subs{i},firstlevel_dir,'right_hemi/',conImage];
end


% Import covariates
for i = 1:numCov

    matlabbatch{1}.spm.stats.factorial_design.cov(i).cname = Cov_names{i};
    
    matlabbatch{1}.spm.stats.factorial_design.cov(i).iCFI = 1;

    matlabbatch{1}.spm.stats.factorial_design.cov(i).iCC = 1;
    
    % Find index of covariates
    idx = strmatch(Cov_names{i},heading,'exact');
    
    % duplicate and concatenate to account for hemisphere
    Cov_temp = [B(:,idx);B(:,idx)];

    matlabbatch{1}.spm.stats.factorial_design.cov(i).c = Cov_temp;

end

matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 0;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'/projects/kg98/kristina/GenofCog/masks/fep-3mm-bin.img,1'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


% ------------------------------------------------------------------------------
% Estimate
% ------------------------------------------------------------------------------
matlabbatch{2}.spm.stats.fmri_est.spmmat = {[outdir,'SPM.mat']};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

% ------------------------------------------------------------------------------
% Contrasts -  I think the first two columns in the cov matrix are the seeds
% These are followed by the main variables e.g. factor scores that we want to map
% Covariates that we want to control should don't have to be incl in the contrasts?
% ------------------------------------------------------------------------------
matlabbatch{3}.spm.stats.con.spmmat = {[outdir,'SPM.mat']};
matlabbatch{3}.spm.stats.con.delete = 1;

matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'SchizPos';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [0 0 0 0 1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'SchizG';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [0 0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'SchizNeg';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 0 0 1 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';



% ------------------------------------------------------------------------------
% Run
% ------------------------------------------------------------------------------
spm_jobman('run',matlabbatch);
clear matlabbatch

cd(outdir)