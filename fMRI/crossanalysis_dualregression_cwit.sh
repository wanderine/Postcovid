#!/bin/bash

# Coding (processhastighet): dorsal attention network (DAN), salience network (SN)
# RUFF (uppmärksamhet): DAN, SN
# CWIT ex (exekutiv funktion): SN, executive network (fronto parietal)
# CWIT speed (processing speed): DAN, SN

# Coding är kolumn P
# RUFF är kolumn K
# CWIT ex är kolumn R
# CWIT speed är kolumn T

analysis=DRgroup_covariates_slicetiming_40components
destination=DualRegressionCrossanalyses

mask=${analysis}/mysmallmask.nii.gz

icamaps_exec_left=${analysis}/dr_stage2_ic0004.nii.gz
icamaps_exec_right=${analysis}/dr_stage2_ic0009.nii.gz
icamaps_dan=${analysis}/dr_stage2_ic0005.nii.gz  
icamaps_sal=${analysis}/dr_stage2_ic0021.nii.gz
icamaps_front=${analysis}/dr_stage2_ic0015.nii.gz


# CWIT ex, removing subject 47, due to missing neuro psych value, index 38 in the ICA maps file
# Remove subject 59, due to no neuro psych values, index 48 in the ICA maps file

# EXEC left

rm temp_exec_left.nii.gz
rm exec_reduced_left.nii.gz
rm firstpart.nii.gz
rm secondpart.nii.gz
rm thirdpart.nii.gz

cp ${icamaps_exec_left} temp_exec_left.nii.gz
fslroi temp_exec_left.nii.gz firstpart.nii.gz 0 38
fslroi temp_exec_left.nii.gz secondpart.nii.gz 39 9
fslroi temp_exec_left.nii.gz thirdpart.nii.gz 49 20
fslmerge -t exec_reduced_left.nii.gz firstpart.nii.gz secondpart.nii.gz thirdpart.nii.gz

# EXEC right

rm temp_exec_right.nii.gz
rm exec_reduced_right.nii.gz
rm firstpart.nii.gz
rm secondpart.nii.gz

cp ${icamaps_exec_right} temp_exec_right.nii.gz
fslroi temp_exec_right.nii.gz firstpart.nii.gz 0 38
fslroi temp_exec_right.nii.gz secondpart.nii.gz 39 9
fslroi temp_exec_right.nii.gz thirdpart.nii.gz 49 20
fslmerge -t exec_reduced_right.nii.gz firstpart.nii.gz secondpart.nii.gz thirdpart.nii.gz

# SAL

rm temp_sal.nii.gz
rm sal_reduced_cwit.nii.gz
rm firstpart.nii.gz
rm secondpart.nii.gz
rm thirdpart.nii.gz

cp ${icamaps_sal} temp_sal.nii.gz
fslroi temp_sal.nii.gz firstpart.nii.gz 0 38
fslroi temp_sal.nii.gz secondpart.nii.gz 39 9
fslroi temp_sal.nii.gz thirdpart.nii.gz 49 20
fslmerge -t sal_reduced_cwit.nii.gz firstpart.nii.gz secondpart.nii.gz thirdpart.nii.gz



# DAN

rm temp_dan.nii.gz
rm dan_reduced_cwit.nii.gz
rm firstpart.nii.gz
rm secondpart.nii.gz
rm thirdpart.nii.gz

cp ${icamaps_dan} temp_dan.nii.gz
fslroi temp_dan.nii.gz firstpart.nii.gz 0 38
fslroi temp_dan.nii.gz secondpart.nii.gz 39 9
fslroi temp_dan.nii.gz thirdpart.nii.gz 49 20
fslmerge -t dan_reduced_cwit.nii.gz firstpart.nii.gz secondpart.nii.gz thirdpart.nii.gz



# front

rm temp_front.nii.gz
rm front_reduced_cwit.nii.gz
rm firstpart.nii.gz
rm secondpart.nii.gz
rm thirdpart.nii.gz

cp ${icamaps_front} temp_front.nii.gz
fslroi temp_front.nii.gz firstpart.nii.gz 0 38
fslroi temp_front.nii.gz secondpart.nii.gz 39 9
fslroi temp_front.nii.gz thirdpart.nii.gz 49 20
fslmerge -t front_reduced_cwit.nii.gz firstpart.nii.gz secondpart.nii.gz thirdpart.nii.gz



#---------------------------------------------------------------------------------


# CWIT ex

# EXEC left 
randomise -i exec_reduced_left.nii.gz -o ${destination}/crossanalysis_cwitex_exec_left -m ${analysis}/fp2_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_crossanalysis_cwitex.mat -t fMRIAnalyses/group_covariates_crossanalysis.con -n 5000 -T -D &

# EXEC right
randomise -i exec_reduced_right.nii.gz -o ${destination}/crossanalysis_cwitex_exec_right -m ${analysis}/fp1_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_crossanalysis_cwitex.mat -t fMRIAnalyses/group_covariates_crossanalysis.con -n 5000 -T -D &

# SAL
randomise -i sal_reduced_cwit.nii.gz -o ${destination}/crossanalysis_cwitex_salience -m ${analysis}/sal_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_crossanalysis_cwitex.mat -t fMRIAnalyses/group_covariates_crossanalysis.con -n 5000 -T -D &


# front
randomise -i front_reduced_cwit.nii.gz -o ${destination}/crossanalysis_cwitex_front -m ${analysis}/exec_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_crossanalysis_cwitex.mat -t fMRIAnalyses/group_covariates_crossanalysis.con -n 5000 -T -D &



#---------------------------------------------------------------------------------

# CWIT speed


# DAN 
randomise -i dan_reduced_cwit.nii.gz -o ${destination}/crossanalysis_cwitspeed_dan -m ${analysis}/dan_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_crossanalysis_cwitspeed.mat -t fMRIAnalyses/group_covariates_crossanalysis.con -n 5000 -T -D &

# SAL
randomise -i sal_reduced_cwit.nii.gz -o ${destination}/crossanalysis_cwitspeed_salience -m ${analysis}/sal_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_crossanalysis_cwitspeed.mat -t fMRIAnalyses/group_covariates_crossanalysis.con -n 5000 -T -D &

randomise -i front_reduced_cwit.nii.gz -o ${destination}/crossanalysis_cwitspeed_front -m ${analysis}/exec_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_crossanalysis_cwitspeed.mat -t fMRIAnalyses/group_covariates_crossanalysis.con -n 5000 -T -D &

