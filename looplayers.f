C FILE: LOOPLAYERS.F

      SUBROUTINE LOOP_LAYERS(Vel,tracer,layers_bounds,MapFact,MapIndex,
     &          CellIndex,dZZf,Ni,
     &          NZ,Nlayers,NZZ,VHout)
     
      INTEGER NZ,Nlayers,NZZ,Ni
      REAL*4 layers_bounds(Nlayers)
      REAL*4 Vel(NZ,Ni)
      REAL*4 tracer(NZ,Ni)
      REAL*4 VH(Nlayers)
      REAL*4 VHout(Nlayers,Ni)
      REAL*4 MapFact(NZZ)
      INTEGER MapIndex(NZZ)
      INTEGER CellIndex(NZZ)
      REAL*4 dZZf(NZZ)
Cf2py intent(in) Vel
Cf2py intent(in) tracer,layers_bounds
Cf2py intent(in) MapFact,MapIndex
Cf2py intent(in) CellIndex,dZZf
Cf2py intent(in) Ni,NZ,Nlayers
Cf2py intent(in) NZZ
Cf2py intent(out) VHout
Cf2py external :: layers_1
Cf2py depend(Nlayers) VH
      DO i=1,Ni
         CALL LAYERS_1(Vel(:,i),tracer(:,i),layers_bounds,
     &          MapFact,MapIndex,
     &          CellIndex,dZZf,
     &          NZ,Nlayers,NZZ,VH)
      DO kk=1,Nlayers
          VHout(kk,i)=VH(kk)
      ENDDO
      ENDDO
      
      
      END SUBROUTINE
      

C END FILE LOOPLAYERS.F