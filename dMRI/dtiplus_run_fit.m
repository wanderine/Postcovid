% script to run dti+
function dtiplus_run_fit()

%% load the nifti files and the header to be attached
% assumes that there is a mean b0 image called "mean_b0.nii"
% this file should have the correct sizes for voxel & pix dimesions
% but we need to tell that the datatype is double after processing
nii_h = niftiinfo('mean_bzero.nii');
nii_h.Datatype = 'double';
nii_h.BitsPerPixel = 64;
nii_h.raw.datatype = 64;
nii_h.raw.bitpix = 64;

% load the preprocessed data and the mask
data =  niftiread('dwi.nii');
%mask =  niftiread('mask.nii.gz');
%mask =  niftiread('b0_brain_mask.nii.gz');
mask =  niftiread('my_hifi_b0_brain_mask.nii.gz');

%% define new xps based on new bvecs and bvals
bval_fn = 'dwi.bval';
bvec_fn = 'dwi.bvec';
bval = load(bval_fn);
bvec = load(bvec_fn);
bt = get_btensors_from_bvec_bval(bvec, bval);

% only run DTI on the data acquired with bvals < 1500
indx = bval < 1500;

%% run dtiplus (SDPd and NLLDd)
[m_DTIp, dps_DTIp] = qtiplus_fit(data, bt,...
    'mask', mask,...
    'pipeline', 10, ...
    'ind', indx');

%% save m and dps in new folder
curr_fold = pwd;
cd('../')
mkdir('DTIp_topup_results')
cd('DTIp_topup_results')

% save model params & derived invariants
save('model', 'm_DTIp')
save('invariants', 'dps_DTIp')

% save DTI maps in nifti format
qtiplus_invariants2nii(dps_DTIp, nii_h);

%% return to previous folder
cd(curr_fold)

end
