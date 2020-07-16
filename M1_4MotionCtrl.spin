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
long    lgVmin[5]
long    lgVmax[5]
long    lgAcc[5]
long    lgDec[5]

'Var internal
long    i, n
long    lgX1[5]
long    lgX2[5]
long    lgRelDist[5]
long    lgVcalced[5]
word    woState[5]
long    lgDx
long    lgActV[5]
long    lgAccPer10ms[5]

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

PUB Get_lgVcalced(x)
  return lgVcalced[x]

PUB Get_lgRelDist(x)
  return lgRelDist[x]


PUB Get_Done(x)
    return xMoveDone[x]


PUB Set_lgVmax(x,speed)
  lgVmax[x] := speed

PUB Set_lgVmin(x,speed)
  lgVmin[x] := speed

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

PUB WriteSpeed(x, Speed)
  ''..case x
  ''.. 1: long($7040) write
  
PRI MotionLoop

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
        lgAccPer10ms[i] := lgAcc[i] /100  'accelaration in mm/10ms2 '

      
        lgX1[i]                 := ( lgVmax[i] * lgVmax[i] ) / (2 * lgAcc[i] ) 
        lgX2[i]                 := ( lgVmax[i] * lgVmax[i] ) / (2 * lgDec[i] )
        lgDx[i]                 := lgX1[i] + lgX2[i]
        lgRelDist[i]            := lgWntPos[i] - lgActpos[i]

        if  lgRelDist[i] => lgDx[i]
        
          woState[i] := 10              ' trapezoidial move

        else
          if lgRelDist[i] => lgDx[i] * lgVmin[i] / lgVmax[i]
          
            woState[i] := 20           ' triangle move 
            lgVcalced[i] := lgVmax[i] * lgRelDist[i] / lgDx[i]

          else  
            woState[i] := 30

      10: 'Trapezoidial move
      
      ' 'start pulsing

        lgActV[i] := lgAccPer10ms[i]
        ''write speed
        woState[i] := 12
      

      
 
      12: 'Trapezoidial move
        lgActV[i] := lgActV[i] + lgAccPer10ms[i]
        if lgActV[i] > lgVmax[i]
          lgActV[i] := lgVmax[i]
          woState[i] := 11

      10: 'Wait for deceleration point
       '' if lgActpos[i]





      


           
      20: 'Triangle move




           
      30: 'Square move     
      



dat

lgSpeed      