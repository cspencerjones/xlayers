C FILE: FINEGRID.F
      SUBROUTINE FINEGRID(dRf,drC,dRfsize,FineGridFact,dZZf,
     &                    MapIndex,MapFact)
C     
C     CALCULATE THE NEW GRID
C
      INTEGER FineGridFact,kkinit,Nr, dRfsize
      REAL*4 dZZf(dRfsize*FineGridFact)
      REAL*4 dRf(dRfsize)
      REAL*4 drC(dRfsize+1)
      REAL*4 Zf(dRfsize+1)
      REAL*4 Zc(dRfsize)
      REAL*4 ZZc(dRfsize*FineGridFact)
      REAL*4 ZZf(dRfsize*FineGridFact+1)
      INTEGER MapIndex(dRfsize*FineGridFact)
      REAL*4 MapFact(dRfsize*FineGridFact)
      INTEGER NZZ
Cf2py intent(in) dRf,dRfsize,FineGridFact
Cf2py intent(out) dZZf, MapIndex,MapFact
Cf2py depend(dRfsize*FineGridFact) dZZf
Cf2py depend(dRfsize*FineGridFact) MapFact
      kkinit = 1.
      Nr=dRfsize
      DO k=1,Nr
        DO kk=kkinit,kkinit+FineGridFact-1
          dZZf(kk) = dRf(k) / FineGridFact
        ENDDO
        kkinit = kkinit + FineGridFact
      ENDDO
      
C     find the depths
      Zf(1) = 0.
      Zc(1) = drC(1)
      DO k=2,Nr
        Zf(k) = Zf(k-1) + drF(k-1)
        Zc(k) = Zc(k-1) + drC(k)
      ENDDO
      Zf(Nr+1) = Zf(Nr) + drF(Nr)
      
      NZZ = dRfsize*FineGridFact
      
      ZZf(1) = 0. 
      ZZc(1) = 0.5  * dZZf(1)

      DO kk=2,NZZ+1
            ZZf(kk) = ZZf(kk-1) + dZZf(kk-1)
            ZZc(kk-1) = 0.5 * (ZZf(kk) + ZZf(kk-1))
      ENDDO
      
    
      
C     create the interpolating mapping arrays
      k = 1
      DO kk=1,NZZ
C       see if ZZc point is less than the top Zc point
        IF ( ZZc(kk) .LT. Zc(1) ) THEN
          MapIndex(kk) = 1
          MapFact(kk) = 1.
C       see if ZZc point is greater than the bottom Zc point
        ELSE IF ( (ZZc(kk) .GE. Zc(Nr)) .OR. (k .EQ. Nr) ) THEN
          MapIndex(kk) = Nr - 1
          MapFact(kk) = 0.
C       Otherwise we are somewhere in between and need to do interpolation)
        ELSE IF ( (ZZc(kk) .GE. Zc(k))
     &   .AND. (ZZc(kk) .LT. Zc(Nr)) ) THEN
C         Find the proper k value
          DO WHILE (ZZc(kk) .GE. Zc(k+1))
            k = k + 1
          ENDDO
C         If the loop stopped, that means Zc(k) <= ZZc(kk) < ZZc(k+1)
          MapIndex(kk) = k
          MapFact(kk) = 1.0  - (( ZZc(kk) - Zc(k) ) / drC(k+1))
        ELSE
C       This means there was a problem
C          WRITE(msgBuf,'(A,I4,A,I4,A,1E14.6,A,2E14.6)')
C     &     'S/R LAYERS_INIT_FIXED: kk=', kk, ', k=', k,
C     &     ', ZZc(kk)=', ZZc(kk),' , Zc(k)=',Zc(k)
C          CALL PRINT_ERROR( msgBuf, myThid )
C          STOP 'ABNORMAL END: S/R LAYERS_INIT_FIXED'
        ENDIF
      ENDDO

      END
C END FILE FINEGRID.F