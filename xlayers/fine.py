from xlayers import finegrid

def fine(drf,drc,drfsize,FineGridFact):
    """Define the fine grid details needed by layers_numpy
    
    Parameters
    ----------
    drf : array_like
        A 1-dimensional array defining the depth difference between cell edges. 
    drc : array_like
        A 1-dimensional array defining the depth difference between cell centers. 
        Length should be one longer that drf, with the first and last values being 
        the depth difference between the the cell center and the domain surface/bottom.
    drfsize : int
        The length of drf.
    FineGridFact : int
        The factor by which the grid is refined for binning in the layers package. 10 is
        the recommended value. 
        
    Returns
    -------
    drf_finer : array
        Refined array of the depth difference between cell edges. 
    mapindex : array
        Index required by layers_numpy
    mapfact : array
        Factor required by layers_numpy
    cellindex : array
        Index required by layers_numpy
    """
    drf_finer, mapindex, mapfact, cellindex=finegrid.finegrid(drf,drc,[drfsize,FineGridFact])
    return drf_finer, mapindex, mapfact, cellindex