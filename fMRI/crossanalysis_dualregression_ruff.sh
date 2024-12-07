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

icamaps_dan=${analysis}/dr_stage2_ic0005.nii.gz  
icamaps_sal=${analysis}/dr_stage2_ic0021.nii.gz
icamaps_front=${analysis}/dr_stage2_ic0015.nii.gz

#---------------------------------------------------------------------------------

# RUFF, removing subjects 15 and 22, which are index 10 and 16 in the ICA maps file
# Remove subject 59, due to no neuro psych values, index 48 in the ICA maps file

# DAN
rm temp_dan.nii.gz
rm dan_reduced_ruff.nii.gz
rm firstpart.nii.gz
rm secondpart.nii.gz
rm thirdpart.nii.gz
rm fourthpart.nii.gz

cp ${icamaps_dan} temp_dan.nii.gz
fslroi temp_dan.nii.gz firstpart.nii.gz 0 10
fslroi temp_dan.nii.gz secondpart.nii.gz 11 5
fslroi temp_dan.nii.gz thirdpart.nii.gz 17 31
fslroi temp_dan.nii.gz fourthpart.nii.gz 49 20 
fslmerge -t dan_reduced_ruff.nii.gz firstpart.nii.gz secondpart.nii.gz thirdpart.nii.gz fourthpart.nii.gz 

# SAL
rm temp_sal.nii.gz
rm sal_reduced_ruff.nii.gz
rm firstpart.nii.gz
rm secondpart.nii.gz
rm thirdpart.nii.gz
rm fourthpart.nii.gz

cp ${icamaps_sal} temp_sal.nii.gz
fslroi temp_sal.nii.gz firstpart.nii.gz 0 10
fslroi temp_sal.nii.gz secondpart.nii.gz 11 5
fslroi temp_sal.nii.gz thirdpart.nii.gz 17 31 
fslroi temp_sal.nii.gz fourthpart.nii.gz 49 20
fslmerge -t sal_reduced_ruff.nii.gz firstpart.nii.gz secondpart.nii.gz thirdpart.nii.gz fourthpart.nii.gz



# front
rm temp_front.nii.gz
rm front_reduced_ruff.nii.gz
rm firstpart.nii.gz
rm secondpart.nii.gz
rm thirdpart.nii.gz
rm fourthpart.nii.gz

cp ${icamaps_front} temp_front.nii.gz
fslroi temp_front.nii.gz firstpart.nii.gz 0 10
fslroi temp_front.nii.gz secondpart.nii.gz 11 5
fslroi temp_front.nii.gz thirdpart.nii.gz 17 31 
fslroi temp_front.nii.gz fourthpart.nii.gz 49 20
fslmerge -t front_reduced_ruff.nii.gz firstpart.nii.gz secondpart.nii.gz thirdpart.nii.gz fourthpart.nii.gz


# DAN 
randomise -i dan_reduced_ruff.nii.gz -o ${destination}/crossanalysis_ruff_dan -m ${analysis}/dan_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_crossanalysis_ruff.mat -t fMRIAnalyses/group_covariates_crossanalysis.con -n 5000 -T -D &

# SAL
randomise -i sal_reduced_ruff.nii.gz -o ${destination}/crossanalysis_ruff_salience -m ${analysis}/sal_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_crossanalysis_ruff.mat -t fMRIAnalyses/group_covariates_crossanalysis.con -n 5000 -T -D &

# front
randomise -i front_reduced_ruff.nii.gz -o ${destination}/crossanalysis_ruff_front -m ${analysis}/exec_mask_binary.nii.gz -d fMRIAnalyses/group_covariates_crossanalysis_ruff.mat -t fMRIAnalyses/group_covariates_crossanalysis.con -n 5000 -T -D &

