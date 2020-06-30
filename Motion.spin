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

byte xM1Enable
byte xM2Enable
byte xM3Enable
byte xM4Enable

long lgM1SollPos
long lgM2SollPos
long lgM3SollPos
long lgM4SollPos

long lgM1IstPos
long lgM2IstPos
long lgM3IstPos
long lgM4IstPos

word woM1Speed
word woM2Speed
word woM3Speed
word woM4Speed

long lgM1Acc
long lgM2Acc
long lgM3Acc
long lgM4Acc

long lgM1Dec
long lgM2Dec
long lgM3Dec
long lgM4Dec

b

long lgActualPos1         
long lgStartTime1             
long lgExecuteTime1               

word woPulsCount1     
word woMaxPulsCount1       

byte byPinDirection1    
byte byPinStepPuls1         
byte xRun1                      
byte xDirectionBackward1            
byte byCogID1

byte byM1State
byte byM2State
byte byM3State
byte byM4State


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
           byM1State := 1
           xM1Running := TRUE

    1:  'Calculations

      xShortTrack := ( lgM1SollPos - long[hubM1ActPos] ) <= woM1Speed

      IF xShortTrack
        woCalcMaxSpeed := lgSollPosition - long[hubM1ActPos]
      else
        woCalcMaxSpeed := woM1Speed
        
      byM1State := 2
    
    2:
      ''IF lgM1SollPos-lgM1IstPos < lgM1DecDistance
             byM1State := 3

    case 3:
      ''woM1ActualSpeed := woM1ActualSpeed - (lgM1Dec/100)


      ''IF lgM1SollPos-lgM1IstPos < lgM1HystPos
             byM1State := 4

    case 4:
      ''IF !M1Run         
        xM1Running := FALSE
            


  IF xM1RampingUp
      woM1ActualSpeed := woM1ActualSpeed + (lgM1Acc/100)
      IF woM1ActualSpeed >= WOMaxSpeed
              

  
  if Run
    case x
      1: long[hubCtrlM1_4] := long[hubCtrlM1_4] & !bit1  
      2: long[hubCtrlM1_4] := long[hubCtrlM1_4] & !bit9
      3: long[hubCtrlM1_4] := long[hubCtrlM1_4] & !bit17
      4: long[hubCtrlM1_4] := long[hubCtrlM1_4] & !bit25
  else
    case x
      1: long[hubCtrlM1_4] := long[hubCtrlM1_4] | bit1  
      2: long[hubCtrlM1_4] := long[hubCtrlM1_4] | bit9
      3: long[hubCtrlM1_4] := long[hubCtrlM1_4] | bit17
      4: long[hubCtrlM1_4] := long[hubCtrlM1_4] | bit25
      }}

DAT

hubM1ActPos             long $7020
hubM2ActPos             long $7024
hubM3ActPos             long $7028
hubM4ActPos             long $702C