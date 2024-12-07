#!/bin/bash

# conda activate postcovid

datapath=/home/andek67/Data/Postcovid

for i in /home/andek67/Data/Postcovid/* ; do

    # Grab the subject folder name
	  subj="$(basename "$i")"	
    echo "Processing" $subj

    if [ -d "$datapath/${subj}/proc_dwi_topup" ]; then
       	 echo "Skipping $subj. Destination folder already exists."
        continue
   	fi

    cd $datapath/${subj}

    # Check if this is a subject folder or not
    if [[ $subj == *"SP2"* ]]; then
        echo "This is a subject"
    else
        echo $subj
        continue
    fi

    # Check if preprocessing has already been done
    if [ -f "$datapath/${subj}/proc_dwi_topup/dwi.nii" ]; then
       	echo "Skipping $subj. Preprocessing already done."
        continue
    else
        echo "Processing $subj"
   	fi

    rm -rf proc_dwi_topup
	  mkdir proc_dwi_topup
	  cd proc_dwi_topup
	  mkdir eddy

    cd ..

    # AP data
    cp -v MAPMRI_DTI_105dir_*.nii  $datapath/${subj}/proc_dwi_topup/eddy/dwi_raw_AP.nii
	  cp -v MAPMRI_DTI_105dir_*.bvec $datapath/${subj}/proc_dwi_topup/eddy/dwi_raw_AP.bvec
	  cp -v MAPMRI_DTI_105dir_*.bval $datapath/${subj}/proc_dwi_topup/eddy/dwi_raw_AP.bval
	  cp -v MAPMRI_DTI_105dir_*.json $datapath/${subj}/proc_dwi_topup/eddy/dwi_raw_AP.json

    # PA data only one volume
    cp -v MAPMRI_DTI_PA_*.nii  $datapath/${subj}/proc_dwi_topup/eddy/dwi_raw_PA.nii
	
	  cd proc_dwi_topup/eddy

    printf "0 -1 0 0.03630\n0 1 0 0.03630\n" > acqparams.txt
    
	  # get b0 volumes for AP and PA
    # first volume, 0, is b0
	  mrconvert dwi_raw_AP.nii -coord 3 0 b0_AP.nii

    if [[ $subj == *"01SP2"* ]]; then
        echo "Full PA dataset, get first volume"
        mrconvert dwi_raw_PA.nii -coord 3 0 b0_PA.nii    
    else
        echo "Single PA volume"
        cp dwi_raw_PA.nii b0_PA.nii
    fi
    fslmerge -t all_b0 b0_AP b0_PA
 
    # run topup to correct for geometric distortions
    topup --imain=all_b0 --datain=acqparams.txt --config=b02b0.cnf --out=my_topup_results --iout=my_hifi_b0

    # apply topup
    #applytopup --imain=dwi_raw_AP,dwi_raw_PA --inindex=1,2 --datain=acqparams.txt --topup=my_topup_results --out=my_hifi_images

    # make a brain mask
    fslmaths my_hifi_b0 -Tmean my_hifi_b0 
    bet my_hifi_b0 my_hifi_b0_brain -m -f 0.2

	  # Make text file specifying the acquisition parameters for each volume
	  indx=""
	  for ((i=1; i<=106; i+=1)); do indx="$indx 1"; done
	  echo $indx > index.txt

	  # run eddy for combined dataset, with topup
	  eddy --imain=dwi_raw_AP --mask=my_hifi_b0_brain_mask --acqp=acqparams.txt --index=index.txt --bvecs=dwi_raw_AP.bvec --bvals=dwi_raw_AP.bval --topup=my_topup_results --repol=sqr --slm=quadratic --flm=quadratic --data_is_shelled --out=dwi_eddy

    mv dwi_eddy.eddy_rotated_bvecs dwi.bvec
    mrconvert dwi_eddy.nii.gz dwi.mif -fslgrad dwi.bvec dwi_raw_AP.bval
	
	  # convert to nifti with nice names & get the b0 image if needed for registration 
    mrconvert dwi.mif dwi.nii -export_grad_fsl dwi.bvec dwi.bval -force
	  dwiextract dwi.mif - -bzero | mrmath - mean mean_bzero.mif -axis 3
    mrconvert mean_bzero.mif mean_bzero.nii
	
    # Move results to proc folder
    mv mean_bzero.nii ../
    mv dwi.nii ../
	  mv dwi.bvec ../
	  mv dwi.bval ../
    mv my_hifi_b0_brain_mask.nii.gz ../
	
done

