import nibabel as nib
import mosek

from dipy.reconst import mapmri
#from dipy.viz import window, actor
from dipy.data import fetch_cfin_multib, read_cfin_dwi, get_sphere
from dipy.core.gradients import gradient_table
import matplotlib.pyplot as plt
import numpy as np
from dipy.io import read_bvals_bvecs
from dipy.io.image import load_nifti, save_nifti
#from mpl_toolkits.axes_grid1 import make_axes_locatable

subject = '01SP2'

print(subject)

# Load brain mask
mask, affine = load_nifti(subject + "/proc_dwi_topup/my_hifi_b0_brain_mask.nii.gz")

# Load preprocessed diffusion data
data, affine, img = load_nifti(subject + "/proc_dwi_topup/dwi.nii", return_img=True)

# Load bvals and bvecs
bvals, bvecs = read_bvals_bvecs(subject + "/proc_dwi_topup/dwi.bval", subject + "/proc_dwi_topup/dwi.bvec")

"""
For the values of the q-space indices to make sense it is necessary to
explicitly state the ``big_delta`` and ``small_delta`` parameters in the
gradient table.
"""

big_delta = 0.0372  # seconds
small_delta = 0.0201 # seconds
gtab = gradient_table(bvals=bvals, bvecs=bvecs,
                      big_delta=big_delta,
                      small_delta=small_delta)

print('data.shape (%d, %d, %d, %d)' % data.shape)
print('data.shape (%d, %d, %d)' % mask.shape)


"""
The MAPMRI Model can now be instantiated. The ``radial_order`` determines the
expansion order of the basis, i.e., how many basis functions are used to
approximate the signal.

First, we must decide to use the anisotropic or isotropic MAPMRI basis. As was
shown in [Fick2016a]_, the isotropic basis is best used for tractography
purposes, as the anisotropic basis has a bias towards smaller crossing angles
in the ODF. For signal fitting and estimation of scalar quantities the
anisotropic basis is suggested. The choice can be made by setting
``anisotropic_scaling=True`` or ``anisotropic_scaling=False``.

First, we must select the method of regularization and/or constraining the
basis fitting.

- ``laplacian_regularization=True`` makes it use Laplacian regularization
  [Fick2016a]_. This method essentially reduces spurious oscillations in the
  reconstruction by minimizing the Laplacian of the fitted signal.
  Several options can be given to select the regularization weight:

    - ``regularization_weighting=GCV`` uses generalized cross-validation
      [Craven1978]_ to find an optimal weight.
    - ``regularization_weighting=0.2`` for example would omit the GCV and
      just set it to 0.2 (found to be reasonable in HCP data [Fick2016a]_).
    - ``regularization_weighting=np.array(weights)`` would make the GCV use
      a custom range to find an optimal weight.

- ``positivity_constraint=True`` makes it use the positivity constraint on the
  diffusion propagator [Ozarslan2013]_. This method constrains the final
  solution of the diffusion propagator to be positive at a set of discrete
  points, since negative values should not exist.

    - The ``pos_grid`` and ``pos_radius`` affect the location and number of
      constraint points in the diffusion propagator.

Both methods do a good job of producing viable solutions to the signal fitting
in practice. The difference is that the Laplacian regularization imposes
smoothness over the entire signal, including the extrapolation beyond the
measured signal. In practice this results in, but does not guarantee positive
solutions of the diffusion propagator. The positivity constraint guarantees a
positive solution in a set of discrete points, which in general results in
smooth solutions, but does not guarantee it.

A suggested strategy is to use a low Laplacian weight together with the
positivity constraint. In this way both desired properties are guaranteed in
the final solution.

We use package CVXPY (http://www.cvxpy.org/) to solve convex optimization
problems when "positivity_constraint=True", so we need to first install
CVXPY.

For now we will generate the anisotropic models for all combinations.
"""

#radial_order = 6
#map_model_laplacian_aniso = mapmri.MapmriModel(gtab, radial_order=radial_order,
#                                               laplacian_regularization=True,
#                                               laplacian_weighting=.2)

#map_model_positivity_aniso = mapmri.MapmriModel(gtab,
#                                                radial_order=radial_order,
#                                                laplacian_regularization=False,
#                                                positivity_constraint=True)

#map_model_both_aniso = mapmri.MapmriModel(gtab, radial_order=radial_order,
#                                          laplacian_regularization=True,
#                                          laplacian_weighting=.05,
#                                          positivity_constraint=True)

radial_order = 6
map_model_plus_aniso = mapmri.MapmriModel(gtab,radial_order=radial_order,
                                         laplacian_regularization=False,
                                         positivity_constraint=True,
                                         global_constraints=True, cvxpy_solver='MOSEK')

map_model_plus_ng = mapmri.MapmriModel(gtab, radial_order=radial_order, positivity_constraint=True, global_constraints=True, bval_threshold=1500, cvxpy_solver='MOSEK')

"""
Note that when we use only Laplacian regularization, the ``GCV`` option may
select very low regularization weights in very anisotropic white matter such
as the corpus callosum, resulting in corrupted scalar indices. In this example
we therefore choose a preset value of 0.2, which has shown to be quite robust
and also faster in practice [Fick2016a]_.

We can then fit the MAPMRI model to the data:
"""

#mapfit_laplacian_aniso = map_model_laplacian_aniso.fit(data)
#mapfit_positivity_aniso = map_model_positivity_aniso.fit(data)
#mapfit_both_aniso = map_model_both_aniso.fit(data, mask=mask)

#fit_method='SDPdc', cvxpy_solver='MOSEK'

mapfit_plus_aniso = map_model_plus_aniso.fit(data, mask=mask)

mapfit_plus_ng = map_model_plus_ng.fit(data, mask=mask)


"""
From the fitted models we will first illustrate the estimation of q-space
indices. For completeness, we will compare the estimation using only Laplacian
regularization, positivity constraint or both. We first show the RTOP
[Ozarslan2013]_.
"""

#rtop_laplacian = np.array(mapfit_laplacian_aniso.rtop()[:, 0, :].T,
#                          dtype=float)
#rtop_positivity = np.array(mapfit_positivity_aniso.rtop()[:, 0, :].T,
#                           dtype=float)
#rtop_both = np.array(mapfit_both_aniso.rtop()[:, 0, :].T, dtype=float)

"""
.. figure:: MAPMRI_maps_regularization.png
   :align: center

It can be seen that all maps appear quite smooth and similar. Though, it is
possible to see some subtle differences near the corpus callosum. The
similarity and differences in reconstruction can be further illustrated by
visualizing the analytic norm of the Laplacian of the fitted signal.
"""

#msd = np.array(mapfit_both_aniso.msd()[:, 0, :].T, dtype=float)

#qiv = np.array(mapfit_both_aniso.qiv()[:, 0, :].T, dtype=float)

#rtop = np.array((mapfit_both_aniso.rtop()[:, 0, :]).T, dtype=float)

#rtap = np.array((mapfit_both_aniso.rtap()[:, 0, :]).T, dtype=float)

#rtpp = np.array(mapfit_both_aniso.rtpp()[:, 0, :].T, dtype=float)




# Save scalar values as nifti files

img = nib.Nifti1Image(mapfit_plus_aniso.msd(), affine)
nib.save(img, subject + '/DTIp_topup_results/MAPMRI/msd.nii.gz')  

img = nib.Nifti1Image(mapfit_plus_aniso.qiv(), affine)
nib.save(img, subject + '/DTIp_topup_results/MAPMRI/qiv.nii.gz')  

img = nib.Nifti1Image(mapfit_plus_aniso.rtop(), affine)
nib.save(img, subject + '/DTIp_topup_results/MAPMRI/rtop.nii.gz')  

img = nib.Nifti1Image(mapfit_plus_aniso.rtap(), affine)
nib.save(img, subject + '/DTIp_topup_results/MAPMRI/rtap.nii.gz')  

img = nib.Nifti1Image(mapfit_plus_aniso.rtpp(), affine)
nib.save(img, subject + '/DTIp_topup_results/MAPMRI/rtpp.nii.gz')  

img = nib.Nifti1Image(mapfit_plus_ng.ng(), affine)
nib.save(img, subject + '/DTIp_topup_results/MAPMRI/ng.nii.gz') 

img = nib.Nifti1Image(mapfit_plus_ng.ng_perpendicular(), affine)
nib.save(img, subject + '/DTIp_topup_results/MAPMRI/ng_perpendicular.nii.gz') 

img = nib.Nifti1Image(mapfit_plus_ng.ng_parallel(), affine)
nib.save(img, subject + '/DTIp_topup_results/MAPMRI/ng_parallel.nii.gz') 


"""

From left to right:

- Mean Squared Displacement (MSD) is a measure for how far protons are able to
  diffuse. a decrease in MSD indicates protons are hindered/restricted more,
  as can be seen by the high MSD in the CSF, but low in the white matter.
- Q-space Inverse Variance (QIV) is a measure of variance in the signal, which
  is said to have higher contrast to white matter than the MSD
  [Hosseinbor2013]_. We also showed that QIV has high sensitivity to tissue
  composition change in a simulation study [Fick2016b]_.
- Return to origin probability (RTOP) quantifies the probability that a proton
  will be at the same position at the first and second diffusion gradient
  pulse. A higher RTOP indicates that the volume a spin is inside of is
  smaller, meaning more overall restriction. This is illustrated by the low
  values in CSF and high values in white matter.
- Return to axis probability (RTAP) is a directional index that quantifies
  the probability that a proton will be along the axis of the main eigenvector
  of a diffusion tensor during both diffusion gradient pulses. RTAP has been
  related to the apparent axon diameter [Ozarslan2013]_ [Fick2016a]_ under
  several strong assumptions on the tissue composition and acquisition
  protocol.
- Return to plane probability (RTPP) is a directional index that quantifies the
  probability that a proton will be on the plane perpendicular to the main
  eigenvector of a diffusion tensor during both gradient pulses. RTPP is
  related to the length of a pore [Ozarslan2013]_ but in practice should be
  similar to that of Gaussian diffusion.

It is also possible to estimate the amount of non-Gaussian diffusion in every
voxel [Ozarslan2013]_. This quantity is estimated through the ratio between
Gaussian volume (MAPMRI's first basis function) and the non-Gaussian volume
(all other basis functions) of the fitted signal. For this value to be
physically meaningful we must use a b-value threshold in the MAPMRI model. This
threshold makes the scale estimation in MAPMRI only use samples that
realistically describe Gaussian diffusion, i.e., at low b-values.
"""


