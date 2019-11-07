from xlayers import finegrid

def fine(drf,drc,drfsize,FineGridFact):
    drf_finer, mapindex, mapfact, cellindex=finegrid.finegrid(drf,drc,[drfsize,FineGridFact])
    return drf_finer, mapindex, mapfact, cellindex