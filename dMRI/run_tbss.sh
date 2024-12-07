cd TBSS

# Start with FA images
tbss_1_preproc *.nii

tbss_2_reg -T 

tbss_3_postreg -S

tbss_4_prestats 0.3

# Use registrations from FA for other metrics
tbss_non_FA MD
tbss_non_FA AD
tbss_non_FA RD
tbss_non_FA qiv
tbss_non_FA msd
tbss_non_FA ng
tbss_non_FA rtop
  

cd FA
imglob *_FA.*

cd stats

randomise -i all_FA_skeletonised -o tbss_FA -m mean_FA_skeleton_mask -d ../group_covariates.mat -t ../group_covariates.con -n 5000 --T2 &

#randomise -i all_MD_skeletonised -o tbss_MD -m mean_FA_skeleton_mask -d ../group_covariates.mat -t ../group_covariates.con -n 5000 --T2 &

#randomise -i all_RD_skeletonised -o tbss_RD -m mean_FA_skeleton_mask -d ../group_covariates.mat -t ../group_covariates.con -n 5000 --T2 &

#randomise -i all_AD_skeletonised -o tbss_AD -m mean_FA_skeleton_mask -d ../group_covariates.mat -t ../group_covariates.con -n 5000 --T2 &


randomise -i all_FA_skeletonised -o tbss_FA_ANOVA -m mean_FA_skeleton_mask -d ../group_covariates_ANOVA.mat -t ../group_covariates_ANOVA.con -n 5000 --T2


randomise -i all_ng_skeletonized -o tbss_ng -m mean_FA_skeleton_mask -d ../group_covariates.mat -t ../group_covariates.con -n 5000 -T

randomise -i all_rtop_skeletonized -o tbss_rtop -m mean_FA_skeleton_mask -d ../group_covariates.mat -t ../group_covariates.con -n 5000 -T




