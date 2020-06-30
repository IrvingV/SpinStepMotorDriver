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

  F: "Float32Full"

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
byte xM1Run            
byte xM1Running            


long x,y,z


PUB Start
   
  byCogID1 := cognew (MotionLoop,0)
  F.start
  

PUB PrintFloatTest

      x := 3.14159265
      y := F.FMUL(2.0,x)
      z := F.FDIV(y,FLOAT(2))

   return z
   

PUB MotionLoop
  



  case byM1State

    0:
      IF xM1Run
           xM1Run := FALSE
           byM1State := 1
           xM1Running := TRUE

    1:
      ''flM1ActualSpeed := flM1ActualSpeed + (flM1Acc10ms)


    
      ''IF woM1ActualSpeed >= woM1MaxSpeed
             byM1State := 2
    {{
    case 2:
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