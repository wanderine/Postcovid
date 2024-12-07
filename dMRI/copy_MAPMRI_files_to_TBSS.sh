#!/bin/bash

data=qiv
preprocessing1=topup_
preprocessing2=_topup

# First patients
for Subject in 1 3 5 6 7; do

    cp 0${Subject}SP2/DTIp_${preprocessing1}results/MAPMRI_fixed/${data}.nii.gz TBSS${preprocessing2}/${data}/p_0${Subject}SP2_FA.nii.gz

done

# Controls
for Subject in 17 18 21 23 24 27 31 38 39 40 41 42 48 55 56 57 58 59 60 61 62 65 66 67 68 69 70 71 72 74 75 77 79 80 81; do

    cp ${Subject}SP2/DTIp_${preprocessing1}results/MAPMRI_fixed/${data}.nii.gz TBSS${preprocessing2}/${data}/c_${Subject}SP2_FA.nii.gz

done

# Patients
for Subject in 10 11 12 13 14 15 16 19 22 25 28 29 30 32 34 35 36 37 43 44 46 47 49 50 51 53 63 64 76; do

    cp ${Subject}SP2/DTIp_${preprocessing1}results/MAPMRI_fixed/${data}.nii.gz TBSS${preprocessing2}/${data}/p_${Subject}SP2_FA.nii.gz

done


#Create a new directory called L2 (or any other name) in your TBSS analysis directory (the one that contains the existing origdata, FA and stats directories from the FA analysis). Type: 

#mkdir L2

#Copy your L2 images into this new directory, making sure that they are named exactly the same as the original FA images were (look in origdata to check the original names - and keep them exactly the same, even if they include FA, which can be confusing; e.g. if there is an image origdata/subj005_FA.nii.gz then you need an image L2/subj005_FA.nii.gz and this file should contain the L2 data, even though it has FA in the name).
#Now, making sure that you are in your top working TBSS directory (the one that now contains FA, stats and L2 subdirectories) and run the tbss_non_FA script, telling it that the alternate data is called L2. This will apply the original nonlinear registration to the L2 data, merge all subjects' warped L2 data into a 4D file stats/all_L2, project this onto the original mean FA skeleton (using the original FA data to find the projection vectors), resulting in the 4D projected data stats/all_L2_skeletonised. Run: tbss_non_FA L2
#You can now run voxelwise stats on the projected 4D data all_L2_skeletonised in the same manner as described above.

