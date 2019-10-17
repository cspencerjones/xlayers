C FILE: FINEGRID.F
      SUBROUTINE FINEGRID(dRf,dRfsize,FineGridFact,dZZf)
C     
C     CALCULATE THE NEW GRID
C
      INTEGER FineGridFact,kkinit,Nr, dRfsize
      REAL*8 dZZf(dRfsize*FineGridFact)
      REAL*4 dRf(dRfsize)
Cf2py intent(in) dRf,dRfsize,FineGridFact
Cf2py intent(out) dZZf
Cf2py depend(dRfsize*FineGridFact) dZZf
      kkinit = 1.
      Nr=dRfsize
      DO k=1,Nr
        DO kk=kkinit,kkinit+FineGridFact-1
          dZZf(kk) = dRf(k) / FineGridFact
        ENDDO
        kkinit = kkinit + FineGridFact
      ENDDO
      END
C END FILE FINEGRID.F