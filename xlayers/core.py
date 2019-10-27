"""
Numpy API for xlayers.
"""
from functools import reduce
import numpy as np
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


def _reshape_outputs(*args, shape=None):
    if len(shape) == 1:
        target_shape = (1,)
    else:
        target_shape = shape
    return [np.reshape(a, target_shape) for a in args]


def layers_numpy(v_in, theta_in, thetalayers, mapfact, mapindex, cellindex, drf_finer):
    original_shape = v_in.shape

    v_out,theta_out = _reshape_inputs(v_in,theta_in)
    VH2 = layers.loop_layers(v_out, theta_out, thetalayers,
                            mapfact, mapindex, cellindex, drf_finer)
    new_shape = list(original_shape)
    new_shape[-1] = thetalayers.size
    new_shape = tuple(new_shape)
    v_lay = np.squeeze(np.array(_reshape_outputs(VH2, shape=new_shape)))
    
    return v_lay
