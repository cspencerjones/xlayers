import numpy as np
from fine import fine

def test_finegrid():
    fine_drf=np.ones(10)
    fine_drc=np.ones(11)
    drf_finer, mapindex, mapfact, cellindex=fine(np.squeeze(fine_drf), 
                                                              np.squeeze(fine_drc),fine_drf.size,10)
    assert(drf_finer[0])==np.float32(0.1)