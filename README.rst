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


Get in touch
------------

- Report bugs, suggest features or view the source code `on GitHub`_.

.. _on GitHub: https://github.com/cspencerjones/xlayers.git
