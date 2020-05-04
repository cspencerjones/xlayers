"""
Numpy API for xlayers.
"""
from functools import reduce
import numpy as np
import xarray as xr
import xlayers.layers as layers

def _prod(v):
    return reduce(lambda x, y: x*y, v)

def _reshape_inputs(*args):
    a0 = args[0]
    shape = a0.shape
    for a in args:
        if a.shape != shape:
            raise ValueError('Input arrays must have the same shape.')

    args_al2d = [np.atleast_2d(a) for a in args]
    original_shape = args_al2d[0].shape
    # calc_cape needs input in shape (nlevs, npoints)
    new_shape = (_prod(original_shape[:-1]),)+(original_shape[-1],)
    args_2d = [np.reshape(a, new_shape) for a in args_al2d]
    return args_2d


def _reshape_outputs(*args, shape = None):
    if len(shape) == 1:
        target_shape = (1,)
    else:
        target_shape = shape
    return [np.reshape(a, target_shape) for a in args]


def layers_xarray(data_in, theta_in, thetalayers, mapfact, mapindex, cellindex, drf_finer, lev_name, Tlev_name):
    """Convert an xarray from depth coordinates to other coordinates
    
    Parameters
    ----------
    data_in : array_like
        Variable that will be remapped. 
    theta_in : array_like
        Variable that defines location of new coordinate system. 
        For example, if you are remapping to temperature coordinates, this should be 
        the temperature on the same grid points as the variable you wish to remap.
    thetalayers : array_like
        Vector of the values to use in the new coordinate system. 
        For example, if you are remapping to temperature coordinates, this should be 
        a vector of temperatures that defines the new coordinate system.
    mapfact : array_like
        Factor required by remapping code. Output from running fine.py.
    mapindex : array_like
        Index required by remapping code. Output from running fine.py.
    cellindex : array_like
        Index required by remapping code. Output from running fine.py.
    drf_finer : array_like
        Depth difference between refined cell edges. Output from running fine.py.
    lev_name : string
        The name of the vertical coordinate in data_in and theta_in
    Tlev_name : string
        The name of the vertical coordinate in the output array
        
    Returns
    -------
    data_out : array
        data_out is an array of the thickness-weighted quantity in the new coordinate system. 

    """
    data_out = xr.apply_ufunc(layers_numpy, data_in, theta_in,
                       kwargs={'thetalayers':thetalayers,'mapfact':mapfact,
                               'mapindex':mapindex,'cellindex':cellindex,
                               'drf_finer':drf_finer},
                       dask='parallelized', 
                       input_core_dims=[[lev_name],[lev_name]], output_core_dims=[[Tlev_name]],
                       output_dtypes=[float], output_sizes={Tlev_name:thetalayers.size}
                       )
    data_out = data_out.assign_coords({Tlev_name:thetalayers})
    return data_out


def layers_numpy(v_in, theta_in, thetalayers, mapfact, mapindex, cellindex, drf_finer):
    """Convert a numpy array from depth coordinates to other coordinates
    
    Parameters
    ----------
    v_in : array_like
        Variable that will be remapped. 
    theta_in : array_like
        Variable that defines location of new coordinate system. 
        For example, if you are remapping to temperature coordinates, this should be 
        the temperature on the same grid points as the variable you wish to remap.
    thetalayers : array_like
        Vector of the values to use in the new coordinate system. 
        For example, if you are remapping to temperature coordinates, this should be 
        a vector of temperatures that defines the new coordinate system.
    mapfact : array_like
        Factor required by remapping code. Output from running fine.py.
    mapindex : array_like
        Index required by remapping code. Output from running fine.py.
    cellindex : array_like
        Index required by remapping code. Output from running fine.py.
    drf_finer : array_like
        Depth difference between refined cell edges. Output from running fine.py.
        
    Returns
    -------
    v_lay : array
        v_lay is an array of the thickness-weighted quantity in the new coordinate system. 

    """
    original_shape = v_in.shape

    v_out,theta_out = _reshape_inputs(v_in,theta_in)
    
    if np.all(thetalayers[1:] >= thetalayers[:-1], axis=0):
        if np.any(np.less(theta_out[:,1:], theta_out[:,:-1], 
                          where=(~np.isnan(theta_out[:,:-1]) & ~np.isnan(theta_out[:,1:])))):
            print("Warning: theta_in may not be monotonically ascending/descending")
    elif np.all(thetalayers[1:] <= thetalayers[:-1], axis=0):
        if np.any(np.greater(theta_out[:,1:], theta_out[:,:-1], 
                          where=(~np.isnan(theta_out[:,:-1]) & ~np.isnan(theta_out[:,1:])))):
            print("Warning: theta_in may not be monotonically ascending/descending")
    else:
        raise ValueError("thetalayers is not monotonic")
    
    VH2 = layers.loop_layers(v_out, theta_out, thetalayers,
                            mapfact, mapindex, cellindex, drf_finer)
    new_shape = list(original_shape)
    new_shape[-1] = thetalayers.size
    new_shape = tuple(new_shape)
    v_lay = np.squeeze(np.array(_reshape_outputs(VH2, shape=new_shape)))
    
    return v_lay


