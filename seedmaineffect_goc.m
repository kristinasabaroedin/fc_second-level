spm 
%==========================================================================
% Add paths - edit this section
%==========================================================================

% Data directory
%datadir = [projdir,'data/'];
datadir = '/projects/kg98/kristina/GenofCog/datadir/derivatives/';

% Analysis output directory
% NOTE, must include .mat file with non imaging data (e.g., GoC_variables.mat)
workdir = [datadir,'secondlevel/'];


% ------------------------------------------------------------------------------
% need to get a list of subs
% ------------------------------------------------------------------------------
sublist = '/projects/kg98/kristina/GenofCog/scripts/sublists/goc_subs.txt'
fileID = fopen(sublist);
ParticipantIDs = textscan(fileID,'%s');
subs = ParticipantIDs{1};
% number of subjects
numSubs = length(subs)

% ------------------------------------------------------------------------------
% Initialise output directory. If already exists, delete and re-initialise
% ------------------------------------------------------------------------------
WhichROIs = 'DiMartino'; % 'TriStri' 'DiMartino'
% Select ROI. 2 = dorsal striatum. 3 = ventral striatum
ROInum = 5;

switch WhichROIs
	case 'TriStri'

		int_dir = 'trimaineffects/';

		if ROInum == 1
			ROIname = 'SM'
		elseif ROInum == 2
			ROIname = 'D'
        elseif ROInum == 3
			ROIname = 'V'
		end

	case 'DiMartino'

		int_dir = 'spheremaineffects/';

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

end

conImage = ['con_000',num2str(ROInum),'.img'];


% ------------------------------------------------------------------------------		
% Make outdir
% ------------------------------------------------------------------------------		


outdir = [workdir,'DiMartino/',int_dir,'/'];
if exist(outdir) == 0
	fprintf(1,'Initialising outdir\n')
	mkdir(outdir)
elseif exist(outdir) == 7
	fprintf(1,'Outdir exists\n')
end

%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
cd(outdir)

fprintf(1,'Initialising SPM...\n')
spm('defaults','fmri');
spm_jobman('initcfg')

%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.stats.factorial_design.dir = {outdir};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.name = 'hemi';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.ancova = 0;
%%

% Left hemisphere


	switch WhichROIs
		case 'TriStri'
			firstlevel_dir = ['/firstlevel/TriStri/'];
		case 'DiMartino'
			firstlevel_dir = ['/firstlevel/DiMartino/'];
	end

	matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).levels = 1;
	for i = 1:numSubs
		matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).scans{i} = [datadir,subs{i},firstlevel_dir,'left_hemi/',conImage];
	end

% Right hemisphere
	

	matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).levels = 2;
	for i = 1:numSubs
		matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).scans{i} = [datadir,subs{i},firstlevel_dir,'right_hemi/',conImage];
	end

%%
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
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

matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Hemi+';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';



% ------------------------------------------------------------------------------
% Run
% ------------------------------------------------------------------------------
spm_jobman('run',matlabbatch);
clear matlabbatch

cd(outdir)
