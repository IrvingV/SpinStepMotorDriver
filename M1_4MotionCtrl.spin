' 
'********************************************************************************
'*  Step Motor Pulscontrol (SPIN language)                                      *
'*  Author: Irving Verijdt                                                      *
'*                                                                              *
'********************************************************************************

CON                                                                           
  _clkmode      = xtal1 + pll16x     
  _xinfreq      = 5_000_000
  
OBJ
 
VAR

' Var in
byte    xMoveStart[5]
long    lgWntPos[5]
long    lgActPos[5]
word    woVmin[5]
word    woVmax[5]
long    lgAcc[5]
long    lgDec[5]

'Var internal
long    i, n
long    lgX1[5]
long    lgX2[5]
long    lgRelDist[5]
word    woVcalced[5]
word    woState[5]

' Var Out
byte    xMoveDone[5]

PUB Start
  ''cogstop(cogid)
  cognew (MotionLoop, 0)

PUB Get_woState(x)
  return woState[x]

PUB Get_lgActPos(x)
  return lgActPos[x]

PUB Get_lgWntPos(x)
  return lgWntPos[x]

PUB Get_lgX1(x)
  return lgX1[x]

PUB Get_lgX2(x)
  return lgX2[x]

PUB Get_woVcalced(x)
  return woVcalced[x]

PUB Get_lgRelDist(x)
  return lgRelDist[x]

PUB Get_Done(x)
    return xMoveDone[x]


PUB Set_woVmax(x,speed)
  woVmax[x] := speed

PUB Set_lgAcc(x,acc)
  lgAcc[x]:=acc

PUB Set_lgDec(x,dec)
  lgDec[x]:=dec

PUB Set_lgActPos(x,pos)
  lgActPos[x]:=pos
 
PUB Set_lgWntPos(x,pos)
  lgWntpos[x]:=pos


PUB StartrelMove(x,dist)
  xMoveStart[1] := true


PRI MotionLoop

  'Parameters
    'woMxSpeed                1..10000                  steps/sec
    'woMxAcc                  100..100000               steps/sec^2
    'woMxDec                  100..100000               steps/sec^2
    'woSollPos                min..max                  steps


  repeat
    waitcnt (cnt+ 100000) 
    i:=1
    n:= woState[i]
    case n

      0: 'wait for start command
         IF xMoveStart[i]
          xMoveStart[i] := false
          xMoveDone[i] := false

          woState[i] := 1

      1:  'Determine type of move

        lgX1[i] := ( woVmax[i] * woVmax[i] ) / (2 * lgAcc[i] ) 
        lgX2[i] := ( woVmax[i] * woVmax[i] ) / (2 * lgDec[i] )
        lgRelDist[i] := lgWntPos[i] - lgActpos[i]

        if  ( lgRelDist[i] ) => ( lgX1[i] + lgX2[i] )
        
          woState[i] := 10
          woVcalced[i] := woVmax[i]

        else
          if lgRelDist[i] / (lgX1[i]-lgX2[i]) =< 0.1   ''10%
          
            woState[i] := 20
            woVcalced[i] := woVmax[i] * ( lgRelDist[i] / ( lgX1[i] - lgX2[i] ) )  percentage berekening maken

          else  
            woState[i] := 30
            woVcalced[i] :=  woVmin[i]
            
      

