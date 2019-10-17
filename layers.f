C FILE: LAYERS.F
      SUBROUTINE LAYERS_LOCATE(xx,Nlayers)

      INTEGER   Nlayers
      REAL*8    xx(Nlayers)
      INTEGER   kl
Cf2py intent(in) xx

C     bisection, following Press et al., Numerical Recipes in Fortran,
C     mostly, because it can be vectorized

        kl=1
        ku=Nlayers+1
        
      END SUBROUTINE





      SUBROUTINE LAYERS_1(tracer,layers_bounds,MapFact,MapIndex,
     &          NZ,Nlayers,NZZ,VH)
C     
C     CALCULATE THE NEW GRID
C
      INTEGER NZ,Nlayers,NZZ
      INTEGER mSteps, kgv
      REAL*4 layers_bounds(Nlayers)
      REAL*4 Vel(NZ)
      REAL*4 tracer(NZ)
      REAL*4 VH(Nlayers)
      REAL*4 MapFact(NZZ)
      INTEGER MapIndex(NZZ)
      REAL*4 Tfact
Cf2py intent(in) tracer,layers_bounds
Cf2py intent(in) MapFact,MapIndex
Cf2py intent(in) NZ,Nlayers
Cf2py intent(in) NZZ
Cf2py intent(out) VH
Cf2py external :: layers_locate
Cf2py depend(Nlayers) VH

C     compute maximum number of steps for bisection method (approx.
C     log2(Nlayers)) as log2(Nlayers) + 1 for safety
      mSteps = int(log10(dble(Nlayers))/log10(2.))+1

C      The temperature index (layer_G) goes from cold to warm.
C      The water column goes from warm (k=1) to cold (k=Nr).
C      So initialize the search with the warmest value.
      kgv = Nlayers

      DO iLa=1,Nlayers
           VH(iLa) = NZ 
C          Hs(kg) = 0. _d 0
C          PIs(kg) = 0. _d 0
C          Vs(kg) = 0. _d 0
      
        DO kk=1,NZZ
          kp1=k+1
          k = MapIndex(kk)
          Tfact = MapFact(kk) *  0.5 * tracer(k) +
     &      (1. -MapFact(kk)) * 0.5 * tracer(kp1)
     
         CALL LAYERS_LOCATE(
     I        layers_bounds(iLa),Nlayers)
        ENDDO
      ENDDO
    
      

      END SUBROUTINE
      
     

C END FILE LAYERS.F