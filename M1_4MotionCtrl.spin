' 
'********************************************************************************
'*  Step Motor Pulscontrol (SPIN language)                                      *
'*  Author: Irving Verijdt                                                      *
'*                                                                              *
'*  Hardware    Inputs:         -                                               *
'*     *                                                         *
'*  Outputs:    * xoForward                                               *
'*              * xoStepPuls                                              *
'*  Hardware                                                              *
'*  Hardware                                                              *


'**************************************************************************

CON                                                                           
  _clkmode      = xtal1 + pll16x     
  _xinfreq      = 5_000_000
  
OBJ

VAR

byte xM1Enable,    xM2Enable,    xM3Enable,    xM4Enable
byte xM1Run,       xM2Run,       xM3Run,       xM4Run
byte xM1Running,   xM2Running,   xM3Running,   xM4Running
byte xM1ShortTrack,xM2ShortTrack,xM3ShortTrack,xM4ShortTrack

byte byM1State,    byM2State,    byM3State,    byM4State

long lgM1SollPos,  lgM2SollPos,  lgM3SollPos,  lgM4SollPos
long lgM1IstPos,   lgM2IstPos,   lgM3IstPos,   lgM4IstPos

word woM1Speed,    woM2Speed,    woM3Speed,    woM4Speed
word woM1MinSpeed, woM2MinSpeed, woM3MinSpeed, woM4MinSpeed
word woM1ActualSpeed,woM2ActualSpeed,woM3ActualSpeed,woM4ActualSpeed
word woM1CalcSpeed,woM2CalcSpeed,woM3CalcSpeed,woM4CalcSpeed

long lgM1Acc,      lgM2Acc,      lgM3Acc,      lgM4Acc
long lgM1Dec,      lgM2Dec,      lgM3Dec,      lgM4Dec
long lgM1Lag,      lgM2lag,      lgM3Lag,      lgM4Lag

long lgM1AccelCalc,lgM2AccelCalc,lgM3AccelCalc,lgM4AccelCalc
long lgM1DecelCalc,lgM2DecelCalc,lgM3DecelCalc,lgM4DecelCalc

long x1,x2

long lgActualPos1         
long lgStartTime1             
long lgExecuteTime1               

byte byCogID1




PUB Start
   
  byCogID1 := cognew (MotionLoop,0)


PUB MotionLoop

  'Parameters
    'woMxSpeed                1..10000                  steps/sec
    'woMxAcc                  100..100000               steps/sec^2
    'woMxDec                  100..100000               steps/sec^2
    'woSollPos                min..max                  steps

    
  case byM1State

    0:
      IF xM1Run
        xM1Run := FALSE
        xM1Running := TRUE

        byM1State := 1

    1:  'Calculations
      x1 := ( woM1Speed * woM1Speed ) / (2 * lgM1Acc ) 
      x2 := ( woM1Speed * woM1Speed ) / (2 * lgM1Dec ) 

      xM1ShortTrack := ( lgM1SollPos - long[hubM1ActPos] ) =<( x1 + x2 )

      lgM1AccelCalc := lgM1Acc / 100
      lgM1DecelCalc := lgM1Dec / 100
      
      byM1State := 2
    
    2:
      woM1ActualSpeed :=  woM1ActualSpeed + lgM1AccelCalc
      IF woM1ActualSpeed > woM1Speed
        woM1ActualSpeed := woM1Speed

      IF xM1ShortTrack      
        IF woM1ActualSpeed := woM1CalcSpeed
             byM1State := 3
      else
        IF lgM1SollPos-lgM1IstPos < x2
             byM1State := 3
  
    3:
      woM1ActualSpeed :=  woM1ActualSpeed - lgM1DecelCalc
      IF woM1ActualSpeed < woM1MinSpeed
        woM1ActualSpeed := woM1Speed
             
      IF lgM1SollPos-lgM1IstPos <= lgM1Lag
             byM1State := 3
    4:
      ''IF !M1Run         
        xM1Running := FALSE
            


  
              

  
 

DAT

hubM1ActPos             long $7020
hubM2ActPos             long $7024
hubM3ActPos             long $7028
hubM4ActPos             long $702C