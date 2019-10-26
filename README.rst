In order to compile f2py

On Pangeo, first install fortran:

conda install -c conda-forge fortran-compiler

unset LDFLAGS

Then to compile a fortran file:

python -m numpy.f2py -c -m finegrid finegrid.f

python -m numpy.f2py -c -m layers looplayers.f layers.f
