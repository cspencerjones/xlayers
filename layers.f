C FILE: LAYERS.F
      SUBROUTINE LAYERS_LOCATE(xx,Nlayers,m,x,k)

      INTEGER   Nlayers
      REAL*4    xx(Nlayers)
      REAL*4    x
      INTEGER   m
      INTEGER   kl, km, ku,k
Cf2py intent(in) xx,Nlayers,m
Cf2py intent(in) x
Cf2py intent(out) k
C     bisection, following Press et al., Numerical Recipes in Fortran,
C     mostly, because it can be vectorized

        kl=1
        ku=Nlayers+1
        
C     This is the bisection loop
       DO l = 1,m
         IF (ku-kl.GT.1) THEN
          km=(ku+kl)/2
CML       IF ((xx(Nlayers).GE.xx(1)).EQV.(x.GE.xx(km))) THEN
          IF ( ((xx(Nlayers).GE.xx(1)).AND.(x.GE.xx(km))).OR.
     &         ((xx(Nlayers).GE.xx(1)).AND.(x.GE.xx(km))) ) THEN
           kl=km
          ELSE
           ku=km
          END IF
         END IF
      END DO
        IF ( x.LT.xx(2) ) THEN
         k=1
        ELSE IF ( x.GE.xx(Nlayers) ) THEN
         k=Nlayers
        ELSE
         k=kl
        END IF
      END SUBROUTINE





      SUBROUTINE LAYERS_1(Vel,tracer,layers_bounds,MapFact,MapIndex,
     &          CellIndex,dZZf,
     &          NZ,Nlayers,NZZ,VH)
C     
C     CALCULATE THE NEW GRID
C
      INTEGER NZ,Nlayers,NZZ
      INTEGER mSteps, kgv,kloc
      REAL*4 layers_bounds(Nlayers)
      REAL*4 Vel(NZ)
      REAL*4 tracer(NZ)
      REAL*4 VH(Nlayers)
      REAL*4 MapFact(NZZ)
      INTEGER MapIndex(NZZ)
      INTEGER CellIndex(NZZ)
      REAL*4 Tfact
      REAL*4 dzfac
      REAL*4 dZZf(NZZ)
Cf2py intent(in) Vel
Cf2py intent(in) tracer,layers_bounds
Cf2py intent(in) MapFact,MapIndex
Cf2py intent(in) CellIndex,dZZf
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

      DO kg=1,Nlayers
           VH(kg) = 0. 
      ENDDO
      
        DO kk=1,NZZ
          k = MapIndex(kk)
          kp1=k+1
          Tfact = MapFact(kk)  * tracer(k) +
     &      (1. -MapFact(kk)) * tracer(kp1)
     
         CALL LAYERS_LOCATE(
     I        layers_bounds,Nlayers,msteps,Tfact,kgv)
        kloc = kgv
C       NEED TO ADD TOPOGRAPHY HERE
        kci = CellIndex(kk)
        dzfac = dZZf(kk)
        VH(kloc) =
     &    VH(kloc) +
     &    dzfac   * Vel(kci)
        ENDDO

      END SUBROUTINE
      
     

C END FILE LAYERS.F