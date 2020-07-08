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
  stpmtr        : "M1_4StepPulsCtrl"

VAR

byte xEnable[5]
byte xStartMove[5]
byte xRunning[5]
byte xShort[5]
byte xTriangle[5]
byte xTrapeze[5]

byte byState[5]

long lgSollPos[5]
long lgIstPos[5]

word woSpeed[5]
word woMinSpeed[5]
word woActualSpeed[5]
word woCalcSpeed[5]

long lgAcc[5]
long lgDec[5]
long lgLag[5]

long lgAccelCalc[5]
long lgDecelCalc[5]

long i, x1,x2

long lgActualPos         
long lgStartTime             
long lgExecuteTime               

byte byCogID1




PUB Start
   
  byCogID1 := cognew (MotionLoop,0)


PUB AutoMode(x, Auto)
  return stpmtr.Automode(x,Auto)      

PUB Enable(x, Enab)
  return stpmtr.Enable(x,Enab)      

PUB SetHomePosition(x, Pos)
  stpmtr.SetHomePosition(x, Pos)      

PUB SetWantedPosition(x, Pos)
  stpmtr.SetWantedPosition(x,Pos)      

PUB JogForward(x, Jog)
  stpmtr.JogForward(x, Jog)       

PUB JogBackward(x, Jog)
  stpmtr.JogBackward(x, Jog)
  
PUB SetMaxCount(x, count)
  stpmtr.SetMaxCount(x, count)

PUB ExecuteTime
  return stpmtr.ExecuteTime

PUB LoopCount
  return stpmtr.LoopCount

PUB Stat
  return stpmtr.Stat  

PUB Direction(x)
  return stpmtr.Direction(x)


PUB Pulsing(x)
  return stpmtr.Pulsing(x)
  

PUB AtPosition(x)
  return stpmtr.AtPosition(x)
  

PUB ActualPosition(x)
  return stpmtr.ActualPosition(x)
 

PUB WantedPosition(x)
  return stpmtr.WantedPosition(x)
 

PUB ActualCount(x)
  return stpmtr.ActualCount(x)
 

PUB MaxCount(x)
  return stpmtr.MaxCount(x)


PUB MotionLoop

  'Parameters
    'woMxSpeed                1..10000                  steps/sec
    'woMxAcc                  100..100000               steps/sec^2
    'woMxDec                  100..100000               steps/sec^2
    'woSollPos                min..max                  steps

  i:=1  
  case byState[i]

    0:
      IF xStartMove[i]
        xRunning[i] := TRUE

        byState[i] := 1

    1:  'Calculations
      xShort[i]                 := false
      xTriangle[i]              := false
      xTrapeze[i]          := false

      x1 := ( woSpeed[i] * woSpeed[i] ) / (2 * lgAcc[i] ) 
      x2 := ( woSpeed[i] * woSpeed[i] ) / (2 * lgDec[i] ) 
      if  ( lgSollPos[i] - stpmtr.ActualPosition(i) ) =< ( x1 + x2 )
        xShort[5] := true

      ''if woCalcSpeed[i] <   

        
      lgAccelCalc[i] := lgAcc[i] / 100
      lgDecelCalc[i] := lgDec[i] / 100
      
      byState[i] := 2
    
    2:
      woActualSpeed[i] :=  woActualSpeed[i] + lgAccelCalc[i]
      IF woActualSpeed[i] > woSpeed[i]
        woActualSpeed[i] := woSpeed[i]

      IF xShort[5]      
        IF woActualSpeed[i] := woCalcSpeed[i]
             byState[i] := 3
      else
        IF lgSollPos[i]-lgIstPos[i] < x2
             byState[i] := 3
  
    3:
      woActualSpeed[i] :=  woActualSpeed[i] - lgDecelCalc[i]
      IF woActualSpeed[i] < woMinSpeed[i]
        woActualSpeed[i] := woSpeed[i]
             
      IF lgSollPos[i]-lgIstPos[i] <= lgLag[i]
             byState[i] := 3
    4:
      ''IF !M1Run         
        xRunning[i] := FALSE
            


  
              

  
 

DAT

hubActPos                long $7020