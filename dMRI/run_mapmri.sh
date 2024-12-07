#!/bin/bash

# conda activate postcovid2

oldsubject='01SP2'

# First patients
for Subject in 1 3 5 6 7; do

    newsubject=`echo 0${Subject}SP2`
    echo $newsubject

    rm MAPMRI_analysis_temp.py
    cp MAPMRI_analysis.py MAPMRI_analysis_temp.py
    
    # Change subject
	  sed -i "s/${oldsubject}/${newsubject}/g" MAPMRI_analysis_temp.py

    python3.9 MAPMRI_analysis_temp.py

done

# Controls
for Subject in 17 18 21 23 24 27 31 38 39 40 41 42 48 55 56 57 58 59 60 61 62 65 66 67 68 69 70 71 72 74 75 77 79 80 81; do

    newsubject=`echo ${Subject}SP2`
    echo $newsubject

    rm MAPMRI_analysis_temp.py
    cp MAPMRI_analysis.py MAPMRI_analysis_temp.py
    
    # Change subject
	  sed -i "s/${oldsubject}/${newsubject}/g" MAPMRI_analysis_temp.py

    python3.9 MAPMRI_analysis_temp.py

done

# Patients
for Subject in 10 11 12 13 14 15 16 19 22 25 28 29 30 32 34 35 36 37 43 44 46 47 49 50 51 53 63 64 76; do

    newsubject=`echo ${Subject}SP2`
    echo $newsubject

    rm MAPMRI_analysis_temp.py
    cp MAPMRI_analysis.py MAPMRI_analysis_temp.py
    
    # Change subject
	  sed -i "s/${oldsubject}/${newsubject}/g" MAPMRI_analysis_temp.py

    python3.9 MAPMRI_analysis_temp.py

done


