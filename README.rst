.. image:: https://img.shields.io/pypi/v/xlayers.svg?style=for-the-badge
    :target: https://pypi.org/project/xlayers
    :alt: Python Package Index

.. image:: https://img.shields.io/conda/vn/conda-forge/xlayers.svg?style=for-the-badge
    :target: https://anaconda.org/conda-forge/xlayers
    :alt: Conda Version
      
.. image:: https://zenodo.org/badge/215552269.svg
   :target: https://zenodo.org/badge/latestdoi/215552269


xlayers: Python implementation of MITgcm's layer package
========================================================

xlayers allows you to transform your data from a regular vertical grid (like depth) to a vertical grid defined based on contours of some variable (like density). xlayers uses FORTRAN code from the layers package of the MITgcm, which was written by Ryan Abernathey. 

We recommend using this package on xarrays, but it can also be applied to numpy
arrays. This `example notebook <https://github.com/cspencerjones/xlayers/blob/master/notebooks/Test_Packaging.ipynb`>_. may be helpful in getting started. 

Why a new vertical regridding package?
--------------------------------------

xlayers has many advantages over other similar tools. It conserves the total quantity of the input variable in the water column: this is particularly important when performing volume or heat budgets in density space. xlayers outputs the thickness-weighted variable in density space, which makes thickness-weighted averaging easier. This output is mapped in a smooth and sensible way. xlayers is also very fast and parallelizable.     
    
Installation
------------


xlayers can be installed from PyPI with pip:

.. code-block:: bash

    python -m pip install xlayers


It is also available from `conda-forge` for conda installations:

.. code-block:: bash

    conda install -c conda-forge xlayers
    
To install xlayers from source repository, the fortran-compiler package is required. The easiest way to install the fortran-compiler is via `conda`_ :

.. code-block:: bash

    conda install -c conda-forge fortran-compiler
    unset LDFLAGS

.. _conda: https://conda-forge.org/

Once the compiler is installed, now we can install xlayers from Github:

.. code-block:: bash

    git clone https://github.com/cspencerjones/xlayers.git
    cd xlayers
    python setup.py install


Features
--------
xlayers is *property conserving*, meaning that the total amount of your variable in the water column will not change when it is transformed into the new coordinate system. 

xlayers acheives this using binning: it bins the variable onto a much finer vertical grid, estimates the depth of the new coordinate surfaces, and adds up these bins in the new space. 


Inputs
------
This package expects your initial coordinate system to be on a structured grid. i.e. it will not take density as an initial vertical variable, but depth is ok.

Before running `layers_xarray`, you must run `finegrid` to define some of the binning parameters needed. `finegrid` takes 2 inputs (which should both be numpy arrays): the vertical depth of the gridcells, and the vertical distance between the centers of the grid cells. The second variable should be loneger by 1 than the first, because it includes the distance between the cell center of the top cell and the sea surface, and the distance between the cell center of the bottom cell and the domain bottom.  

The first two inputs to `layers_xarray` should be on the same gridpoints. `data_in` is the variable to be remapped and `theta_in` is the variable that defines the location of the new coordinate system. 

Outputs
-------
The output of `layers_xarray` is *thickness weighted*, i.e. if the input variable is salinity, the output variable is the salinity in each layer *multiplied by the depth of the layer*. In order to get an output that has the same units as the input, divide by the thickness of the layer (which you can get by inputting an array of ones into `layers_xarray` instead of `data_in`. 


Get in touch
------------

- Report bugs, suggest features or view the source code `on GitHub`_.

.. _on GitHub: https://github.com/cspencerjones/xlayers.git
