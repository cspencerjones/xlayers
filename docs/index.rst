Welcome to xlayers's documentation!
===================================

xlayers allows you to transform your data from a regular vertical grid (like depth) to a vertical grid defined based on contours of some variable (like density). xlayers uses FORTRAN code from the layers package of the MITgcm, which was written by Ryan Abernathey. 

We recommend using this package on xarrays, but it can also be applied to numpy
arrays. 

Why a new vertical regridding package?
--------------------------------------

xlayers has many advantages over other similar tools. It conserves the total quantity of the input variable in the water column: this is particularly important when performing volume or heat budgets in density space. xlayers outputs the thickness-weighted variable in density space, which makes thickness-weighted averaging easier. This output is mapped in a smooth and sensible way. xlayers is also very fast and parallelizable. 


Contents
--------

.. toctree::
   :maxdepth: 2

   api
   contributing
