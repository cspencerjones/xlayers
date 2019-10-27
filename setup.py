 #!/usr/bin/env python
import os
import re
import sys
import warnings
import versioneer
from setuptools import setup, find_packages
from numpy.distutils.core import setup, Extension
from numpy.distutils.fcompiler import get_default_fcompiler, CompilerNotFound

DISTNAME = 'xlayers'
LICENSE = 'MIT'
AUTHOR = 'xlayers Developers'
AUTHOR_EMAIL = 'spencerj@ldeo.columbia.edu'
URL = 'https://github.com/cspencerjones/xlayers'
CLASSIFIERS = [
    'Development Status :: 4 - Beta',
    'License :: OSI Approved :: Apache Software License',
    'Operating System :: OS Independent',
    'Intended Audience :: Science/Research',
    'Programming Language :: Python',
    'Programming Language :: Python :: 3',
    'Programming Language :: Python :: 3.6',
    'Topic :: Scientific/Engineering',
]

INSTALL_REQUIRES = ['xarray>=0.12.0', 'dask', 'numpy>=1.16']
PYTHON_REQUIRES = '>=3.6'


# figure out which compiler we're going to use
compiler = get_default_fcompiler()
# set some fortran compiler-dependent flags
f90flags = []
if compiler == 'gnu95':
    f90flags.append('-fno-range-check')
    f90flags.append('-ffree-form')
elif compiler == 'intel' or compiler == 'intelem':
    f90flags.append('-132')
#  Set aggressive optimization level
f90flags.append('-O3')
#  Suppress all compiler warnings (avoid huge CI log files)
f90flags.append('-w')

finegrid = Extension(name = 'finegrid',
                    sources = ['xlayers/finegrid.f'],
                    extra_f90_compile_args=f90flags,
                    f2py_options=['--quiet'])
layers = Extension(name = 'layers',
                  sources = ['xlayers/looplayers.f',
                            'xlayers/layers.f'],
                  extra_f90_compile_args=f90flags,
                  f2py_options=['--quiet'])

DESCRIPTION = "Fast convective parameters for numpy, dask, and xarray"
def readme():
    with open('README.rst') as f:
        return f.read()

setup(name=DISTNAME,
      version=versioneer.get_version(),
      cmdclass=versioneer.get_cmdclass(),
      license=LICENSE,
      author=AUTHOR,
      author_email=AUTHOR_EMAIL,
      classifiers=CLASSIFIERS,
      description=DESCRIPTION,
      long_description=readme(),
      #install_requires=INSTALL_REQUIRES,
      #python_requires=PYTHON_REQUIRES,
      url=URL,
      packages = find_packages(),
      ext_package = 'xlayers',
      ext_modules = [finegrid, layers]
      )
