#!/bin/bash

analysis=DRgroup_covariates_slicetiming_40components
#destination=DRgroup_covariates_slicetiming_40components/mypermutations

#----------------------------------

randomise -i ${analysis}/dr_stage2_ic0002.nii.gz -o ${destination}/dmn -m ${analysis}/dmn_mask_binary.nii.gz -d fMRIAnalyses/group_covariates.mat -t fMRIAnalyses/group_covariates.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0004.nii.gz -o ${destination}/fp1 -m ${analysis}/fp1_mask_binary.nii.gz -d fMRIAnalyses/group_covariates.mat -t fMRIAnalyses/group_covariates.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0009.nii.gz -o ${destination}/fp2 -m ${analysis}/fp2_mask_binary.nii.gz -d fMRIAnalyses/group_covariates.mat -t fMRIAnalyses/group_covariates.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0021.nii.gz -o ${destination}/sal -m ${analysis}/sal_mask_binary.nii.gz -d fMRIAnalyses/group_covariates.mat -t fMRIAnalyses/group_covariates.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0005.nii.gz -o ${destination}/dan -m ${analysis}/dan_mask_binary.nii.gz -d fMRIAnalyses/group_covariates.mat -t fMRIAnalyses/group_covariates.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0011.nii.gz -o ${destination}/cer -m ${analysis}/cer_mask_binary.nii.gz -d fMRIAnalyses/group_covariates.mat -t fMRIAnalyses/group_covariates.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0015.nii.gz -o ${destination}/exec -m ${analysis}/exec_mask_binary.nii.gz -d fMRIAnalyses/group_covariates.mat -t fMRIAnalyses/group_covariates.con -n 5000 -T &



randomise -i ${analysis}/dr_stage2_ic0002.nii.gz -o ${destination}/dmn_ANOVA -m ${analysis}/dmn_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_ANOVA.mat -t fMRIAnalyses/group_covariates_ANOVA.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0004.nii.gz -o ${destination}/fp1_ANOVA -m ${analysis}/fp1_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_ANOVA.mat -t fMRIAnalyses/group_covariates_ANOVA.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0009.nii.gz -o ${destination}/fp2_ANOVA -m ${analysis}/fp2_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_ANOVA.mat -t fMRIAnalyses/group_covariates_ANOVA.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0021.nii.gz -o ${destination}/sal_ANOVA -m ${analysis}/sal_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_ANOVA.mat -t fMRIAnalyses/group_covariates_ANOVA.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0005.nii.gz -o ${destination}/dan_ANOVA -m ${analysis}/dan_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_ANOVA.mat -t fMRIAnalyses/group_covariates_ANOVA.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0011.nii.gz -o ${destination}/cer_ANOVA -m ${analysis}/cer_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_ANOVA.mat -t fMRIAnalyses/group_covariates_ANOVA.con -n 5000 -T &

randomise -i ${analysis}/dr_stage2_ic0015.nii.gz -o ${destination}/exec_ANOVA -m ${analysis}/exec_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_ANOVA.mat -t fMRIAnalyses/group_covariates_ANOVA.con -n 5000 -T &



