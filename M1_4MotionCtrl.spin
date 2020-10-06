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
  stpmtr        : "M1_4StepPulsCtrl"

VAR

  long    Stack[50] 
  long    cogon, cog

  ' Var in
  byte    xMoveStart[5]
  long    lgWntPos[5]
  long    lgActPos[5]
  long    lgVmin[5]
  long    lgVmax[5]
  long    lgJogSpeed[5]
  long    lgAcc[5]
  long    lgDec[5]

  'Var internal
  byte    byState[5]
  byte    byMoveType[5] '' 1= trapezoidial 2=triangle 3=rectangle
  byte    byAuto[5] 
  word    woError    
  long    i
  long    lgX1[5]
  long    lgX2[5]
  long    lgRelDist[5]
  long    lgVcalced[5]
  long    lgDx[5]
  long    lgActV[5]
  long    lgAccPer10ms[5]
  long    lgAbsDiff[5]
' Var Out
  byte    xMoveDone[5]
  ''long c
  long lgTime
  long startT
  long execT
  long seconds, dT, T
  long lgExecCounter
 
PUB start
  stpmtr.start
  longfill(@Stack, 0, 50)
  cognew (MotionLoop, @Stack)



PUB Get_byState(x)
  return byState[x]

PUB Get_byMoveType(x)
  return byMoveType[x]

PUB Get_lgX1(x)
  return lgX1[x]

PUB Get_lgX2(x)
  return lgX2[x]

PUB Get_lgVcalced(x)
  return lgVcalced[x]

PUB Get_Done(x)
  return xMoveDone[x]

PUB Get_lgActV(x)
  return lgActV[x]

PUB Get_lgAccPer10ms(x)
  return lgAccPer10ms[x]


PUB Get_lgAbsDiff(x)
  return lgAbsDiff[x]

'Setters
PUB Set_lgVmax(x,vmax)
  lgVmax[x] := vmax

PUB Set_lgVmin(x,vmin)
  lgVmin[x] := vmin

PUB Set_lgAcc(x,acc)
  lgAcc[x]:=acc

PUB Set_lgDec(x,dec)
  lgDec[x]:=dec

PUB Set_lgWntPos(x,pos)
  lgWntpos[x]:=pos


'commands
PUB RelMove(x,dist)
  xMoveStart[x] := true
  lgWntPos[x] := lgActPos[x] + dist

PUB AbsMove(x,pos)
  xMoveStart[x] := true
  lgWntPos[x] := pos

PUB Get_woError
  return woError

PUB Reset_woError
  woError := 0

PUB Reset(x)
  byState[x] := 0
  lgWntPos[x]:=lgActPos[x]
  stpmtr.Set_WantPos(x,lgWntPos[x])
  
PUB Set_AutoMode(x, Auto)





PUB Cycles
  return lgExecCounter/100
  
PUB readvar
  return dT
  




PRI MotionLoop

  lgJogSpeed[1]                 := 11
  lgJogSpeed[2]                 := 12
  lgJogSpeed[3]                 := 13
  lgJogSpeed[4]                 := 14

  lgTime :=cnt
  repeat
    waitcnt(lgTime += 1000000*5/6)
    lgExecCounter++
 
    startT:=cnt
    long[$7808]:= cnt


    if byte[$4000] == b0
      byte[$4000] := byte[$4000] & !b0
      byte[$4002] := 1 
      stpmtr.Set_Jog (1, false, false)
      stpmtr.Set_Auto(1, true)

    if byte[$4000] == b1
      byte[$4000] := byte[$4000] & !b1
      byte[$4002] := 2 
      stpmtr.Set_Enable(1, false)
      stpmtr.Set_Auto(1, false)


    if byte[$4000] == b2 and stpmtr.Get_AutoMode(1)
      byte[$4000] := byte[$4000] & !b2
      byte[$4002] := 3 
      stpmtr.Set_Enable(1, true)

    if byte[$4000] == b3
      byte[$4000] := byte[$4000] & !b3
      byte[$4002] := 4 
      stpmtr.Set_Enable(1, false)


    if byte[$4000] == b4 and stpmtr.Get_AutoMode(1)
      byte[$4000] := byte[$4000] & !b4
      byte[$4002] := 5 
      stpmtr.Set_HomePos(1, long[$4004])

    if byte[$4000] == b5 and stpmtr.Get_AutoMode(1)
      byte[$4000] := byte[$4000] & !b5
      byte[$4002] := 6 
      stpmtr.Set_WantPos(1, long[$4008])

    if byte[$4001] == b4 and NOT stpmtr.Get_AutoMode(1)
      byte[$4001] := byte[$4000] & !b4
      byte[$4002] := 7 
      stpmtr.Set_Jog (1, true, false)

    if byte[$4001] == b5 and NOT stpmtr.Get_AutoMode(1)
      byte[$4001] := byte[$4001] & !b5
      byte[$4002] := 8 
      stpmtr.Set_Jog (1, false, true)

    if byte[$4001] == b6
      byte[$4001] := byte[$4001] & !b6
      byte[$4002] := 9 
      stpmtr.Set_Jog (1, false, false)

 
    if byte[$4000] == b6
      byte[$4000] := byte[$4000] & !b6
      byte[$4002] := 10 
      lgJogSpeed[1]:=long[$400C]


    
    i:=1
    ''repeat i from 1 to 4  

      lgActPos[i]:=stpmtr.Get_ActPos(i) 
      byAuto[i] := stpmtr.Get_AutoMode(i)
    
      case byState[i]

         0: 'wait for start command
          lgActV[i]:=0 
          IF xMoveStart[i]
            xMoveStart[i] := false
            xMoveDone[i] := false
            byState[i] := 10

        10: 'Calculate settings   

           'set wanted position 
           case i
             1: stpmtr.Set_WantPos(1,lgWntPos[1])
             2: stpmtr.Set_WantPos(2,lgWntPos[2])
             3: stpmtr.Set_WantPos(3,lgWntPos[3])
             4: stpmtr.Set_WantPos(4,lgWntPos[4])

          'Set acc per 10 msec
           lgAccPer10ms[i] := lgAcc[i] / 100
           

           'Determine type of move and Vmax calculated
           lgX1[i] := ( lgVmax[i] * lgVmax[i] ) / ( 2 * lgAcc[i] ) 
           lgX2[i] := ( lgVmax[i] * lgVmax[i] ) / ( 2 * lgDec[i] )
           lgDx[i] := lgX1[i] + lgX2[i]
           lgAbsDiff[i] := ||(lgWntPos[i] - lgActpos[i]) 
           lgRelDist[i] := lgAbsDiff[i]

           if lgRelDist[i] => lgDx[i]
        
             byMoveType[i] := 1                                                   ' trapezoidial move
             lgVcalced[i] := lgVmax[i]                               

           else
             if lgRelDist[i] => lgDx[i] * lgVmin[i] / lgVmax[i]
          
               byMoveType[i] := 2                                                 ' triangle move 
               lgVcalced[i] := lgVmax[i] * lgRelDist[i] / lgDx[i]

             else                                                                 
               byMoveType[i] := 3                                                 ' rectangle move                               
               lgVcalced[i] := lgVmin[i]                                                                                

           'set first speed
           lgActV[i] := lgAccPer10ms[i]

           'enable control 

           stpmtr.Set_Enable(i,true)
         
           byState[i] := 20  

        20:
           'accelerate till calced speed reached
          lgActV[i] := lgActV[i] + lgAccPer10ms[i]
          if lgActV[i] > lgVcalced[i]
             lgActV[i] := lgVcalced[i]

          lgAbsDiff[i] := ||(lgWntPos[i] - lgActpos[i]) 

           'next step depending on move type      
          case byMoveType[i]
            1: if lgX2[i] > lgAbsDiff[i]               'trapezoidial (if decelerat distance greater than act-wnt
                 byState[i] := 30                      
            2: if lgActV[i] == lgVcalced[i]            'triangle (if calced speed reached)
                 byState[i] := 30
            3: byState[i] := 30                        'rectangle (no condition)

        30:'decelerate
          lgActV[i] := lgActV[i] - lgAccPer10ms[i]
          if lgActV[i] < lgVmin[i]
            lgActV[i] := lgVmin[i]

          if lgWntPos[i]==lgActPos[i]
            byState[i] := 40
            lgActV[i]:=0
           
        40:'wait for start command
          IF !xMoveStart[i]
             xMoveDone[i] := true
             byState[i] := 0

      if byAuto[i]
        stpmtr.Set_Speed(i, lgActV[i])
      else
        stpmtr.Set_Speed(i, lgJogSpeed[i])

    execT := cnt - startT       
                 
DAT

b0                      long $1
b1                      long $2
b2                      long $4
b3                      long $8
b4                      long $10
b5                      long $20
b6                      long $40
b7                      long $80
      