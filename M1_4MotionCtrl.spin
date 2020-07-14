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
byte xMoveStart[5]
byte xMoveDone[5]

long lgSollPos[5]
long lgIstPos[5]
long lgRelativeDistance

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
long woState
 
PUB Start
  ''cogstop(cogid)
  coginit (cogid, MotionLoop, 0)

PUB ProfileState
  return woState

PUB ReadActualPos(x)
 '' return stpmtr.ActualPosition(x)

PUB AutoMode(x, Auto)
''  return stpmtr.Automode(x,Auto)      

PUB SetSpeed(x,speed)

PUB SetAcceleration(x,acc)

PUB SetDeceleration(x,dec)

PUB StartrelMove(x,dist)
  xMoveStart[x] := true
  

PUB Enable(x, Enab)
  ''return stpmtr.Enable(x,Enab)      

PUB SetHomePosition(x, Pos)
  ''stpmtr.SetHomePosition(x, Pos)      

PUB JogForward(x, Jog)
  ''stpmtr.JogForward(x, Jog)       

PUB JogBackward(x, Jog)
  ''stpmtr.JogBackward(x, Jog)
  
PUB SetMaxCount(x, count)
  ''stpmtr.SetMaxCount(x, count)


PUB Done(x)
    return xMoveDone[x]
  

PUB AtPosition(x)
  ''return stpmtr.AtPosition(x)
  

PUB ActualPosition(x)
  
 

PUB WantedPosition(x)
  ''return stpmtr.WantedPosition(x)
 

PUB ActualCount(x)
  ''return stpmtr.ActualCount(x)
 

PUB MaxCount(x)
  ''return stpmtr.MaxCount(x)


PRI MotionLoop

  'Parameters
    'woMxSpeed                1..10000                  steps/sec
    'woMxAcc                  100..100000               steps/sec^2
    'woMxDec                  100..100000               steps/sec^2
    'woSollPos                min..max                  steps


  woState:=3
  repeat
    waitcnt (cnt+ 100000) 
{{    case woState

      0:
        IF xMoveStart[i]
          xMoveDone[i] := false

          woState := 1

      1:  'Determine type of move

        x1[i] := ( woSpeed[i] * woSpeed[i] ) / (2 * lgAcc[i] ) 
        x2[i] := ( woSpeed[i] * woSpeed[i] ) / (2 * lgDec[i] )
{{      
        if  ( lgSollPos[i] - stpmtr.ActualPosition(i) ) =< ( x1[i] + x2[i] )
          woState := 10
          woCalcSpeed[i] := woSpeed[i]
        else
          woCalcSpeed := woSpeed[i] * ( lgRelativeDistance / ( x1[i] - x2[i] ) )
          if lgRelativeDistance / (x1[i]-x2[i]) => 0.1   ''10%
           woState := 20
          else  
            woCalcSpeed :=   0
            woState := 30
          
 }}        

{{        
        lgAccelCalc[i] := lgAcc[i] / 100
        lgDecelCalc[i] := lgDec[i] / 100
      
        woState := 2
    
      10: 'trapezoidual move
        woActualSpeed[i] :=  woActualSpeed[i] + lgAccelCalc[i]
        IF woActualSpeed[i] > woSpeed[i]
          woActualSpeed[i] := woSpeed[i]

      
  
      20: 'triangle move
        woActualSpeed[i] :=  woActualSpeed[i] + lgAccelCalc[i]
        IF woActualSpeed[i] > woSpeed[i]
          woActualSpeed[i] := woSpeed[i]

       IF woActualSpeed[i] := woCalcSpeed[i]
         woState := 21
       else
         IF lgSollPos[i]-lgIstPos[i] < x2
             woState := 3
      3:
        woActualSpeed[i] :=  woActualSpeed[i] - lgDecelCalc[i]
        IF woActualSpeed[i] < woMinSpeed[i]
          woActualSpeed[i] := woSpeed[i]
              
        IF lgSollPos[i]-lgIstPos[i] <= lgLag[i]
          woState := 3
          
 }}