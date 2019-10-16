In order to compile f2py

On Pangeo, first install fortran:
conda install -c conda-forge fortran-compiler
unset LDFLAGS

Then to compile a fortran file:
f2py -c ftype.f -m ftype