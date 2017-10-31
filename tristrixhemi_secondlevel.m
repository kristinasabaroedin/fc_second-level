% This script runs a 3x2 multifactorial design for second level analysis (main effect of TriStri seeds)


spmdir = '/usr/local/spm8/matlab2015b.r6685/';
addpath(spmdir)

spm

% ------------------------------------------------------------------------------
% need to get a list of subs
% ------------------------------------------------------------------------------
sublist = '/projects/kg98/kristina/GenofCog/scripts/sublists/subs_w_FactorScores.txt'
fileID = fopen(sublist);
ParticipantIDs = textscan(fileID,'%s');
subs = ParticipantIDs{1};
% number of subjects
numSubs = length(subs)

datadir = '/projects/kg98/kristina/GenofCog/datadir/derivatives/'
firstlevel_dir = ['/firstlevel/TriStri+GSR/'];
outdir = [datadir,'secondlevel/TriStri+GSR/factorial3x2_N341/']

% make outdir
if exist(outdir) == 0
    fprintf(1,'Initialising outdir\n')
    mkdir(outdir)
elseif exist(outdir) == 7
    fprintf(1,'Output directory already exists\n')
end

%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {outdir};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).name = 'seed';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).levels = 6;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).name = 'hemi';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact(2).ancova = 0;

matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).levels = [1
                                                                    1];
for i = 1:numSubs
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).scans{i} = [datadir,subs{i},firstlevel_dir,'left_hemi/con_0001.img'];
end

matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).levels = [1
                                                                    2];
for i = 1:numSubs
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).scans{i} = [datadir,subs{i},firstlevel_dir,'right_hemi/con_0001.img'];
end

matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(3).levels = [2
                                                                    1];
for i = 1:numSubs
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(3).scans{i} = [datadir,subs{i},firstlevel_dir,'left_hemi/con_0002.img'];
end

matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(4).levels = [2
                                                                    2];
for i = 1:numSubs
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(4).scans{i} = [datadir,subs{i},firstlevel_dir,'right_hemi/con_0002.img'];
end

matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(5).levels = [3
                                                                    1];
for i = 1:numSubs
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(5).scans{i} = [datadir,subs{i},firstlevel_dir,'left_hemi/con_0003.img'];
end

matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(6).levels = [3
                                                                    2];
for i = 1:numSubs
    matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(6).scans{i} = [datadir,subs{i},firstlevel_dir,'right_hemi/con_0003.img'];
end


matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 0;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {'/projects/kg98/kristina/templates/MNI152_T1_2mm_brain_mask.nii,1'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


% ------------------------------------------------------------------------------
% Estimate
% ------------------------------------------------------------------------------
matlabbatch{2}.spm.stats.fmri_est.spmmat = {[outdir,'SPM.mat']};
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

% ------------------------------------------------------------------------------
% Contrasts
% ------------------------------------------------------------------------------
matlabbatch{3}.spm.stats.con.spmmat = {[outdir,'SPM.mat']};
matlabbatch{3}.spm.stats.con.delete = 1;

matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Sensorimotor+';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Dorsal+';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [0 0 1 1 0 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Ventral+';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 0 0 0 1 1];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';



% ------------------------------------------------------------------------------
% Run
% ------------------------------------------------------------------------------
spm_jobman('run',matlabbatch);
clear matlabbatch

cd(outdir)