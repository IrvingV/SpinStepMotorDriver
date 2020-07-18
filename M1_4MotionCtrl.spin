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
byte    byState[5]
byte    byMoveType[5] '' 1= trapezoidial 2=triangle 3=rectangle
long    lgDx
long    lgActV[5]
long    lgAccPer10ms[5]

' Var Out
byte    xMoveDone[5]


PUB Start
  cognew (MotionLoop, 0)


'Getters
PUB Get_byState(x)
  return byState[x]

PUB Get_byMoveType(x)
  return byMoveType[x]

PUB Get_lgActPos(x)
  return lgActPos[x]

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


'Setters
PUB Set_lgVmax(x,speed)
  lgVmax[x] := speed

PUB Set_lgVmin(x,speed)
  lgVmin[x] := speed

PUB Set_lgAcc(x,acc)
  lgAcc[x]:=acc

PUB Set_lgDec(x,dec)
  lgDec[x]:=dec

PUB Set_lgWntPos(x,pos)
  lgWntpos[x]:=pos


'commands
PUB StartRelMove(x,dist)
 
      xMoveStart[x] := true
      lgWntPos[x] := lgActPos[x] - dist

PUB StartAbsMove(x,pos)
 
      xMoveStart[x] := true
      lgWntPos[x] := pos


PUB WriteSpeed(x, Speed)
  if x==1
    long[hubM1MaxCount] := 10000/Speed
  if x==2
    long[hubM2MaxCount] := 10000/Speed
  if x==3
    long[hubM3MaxCount] := 10000/Speed
  if x==4
    long[hubM4MaxCount] := 10000/Speed
  

PRI MotionLoop
  stpmtr.Start
  repeat
    waitcnt (cnt + 100000)
    lgActPos[1]:=long[hubM1Actpos] 
    i:=1
    n:= byState[i]
    
    case n

      00:'wait for start command
         IF xMoveStart[i]
           xMoveDone[i] := false
           byState[i] := 1

      01:'Calculate settings   

         'Set acc per 10 msec
         lgAccPer10ms[i] := lgAcc[i] /100 

         'Determine type of move
         lgX1[i]                 := ( lgVmax[i] * lgVmax[i] ) / (2 * lgAcc[i] ) 
         lgX2[i]                 := ( lgVmax[i] * lgVmax[i] ) / (2 * lgDec[i] )
         lgDx[i]                 := lgX1[i] + lgX2[i]
         lgRelDist[i]            := ||(lgWntPos[i] - lgActpos[i])

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

         byState[i] := 10  

      10:'Start motion
      
         'set first speed
         lgActV[i] := lgAccPer10ms[i]
         ''WriteSpeed(i,lgActV[i])
{{         
         'set wanted position and enable control 
         case i
           1: long[hubM1WntPos] := lgWntPos[1]
              long[hubM1_4Ctrl] := long[hubM1_4Ctrl] or b3+b5 
           2: long[hubM2WntPos] := lgWntPos[2]                                                                      
              long[hubM1_4Ctrl] := long[hubM1_4Ctrl] or b11+b13 
           3: long[hubM3WntPos] := lgWntPos[3]
              long[hubM1_4Ctrl] := long[hubM1_4Ctrl] or b19+b21  
           4: long[hubM4WntPos] := lgWntPos[4]
              long[hubM1_4Ctrl] := long[hubM1_4Ctrl] or b27+b29   
         
         byState[i] := 20  
 
      20:
        'accelerate till calced speed reached
        lgActV[i] := lgActV[i] + lgAccPer10ms[i]
        if lgActV[i] > lgVcalced[i]
           lgActV[i] := lgVcalced[i]

        'next step depending on move type      
        case byMoveType[i]
           1: if lgX2[i] > ||(lgActpos-lgWntPos)        'trapezoidial (if decelerat distance greater than act-wnt
              byState[i] := 30
           2: if lgActV[i] == lgVcalced[i]              'triangle (if calced speed reached)
              byState[i] := 30
           3: byState[i] := 30                          'rectangle (no condition)

      30:
        'decelerate
        lgActV[i] := lgActV[i] - lgAccPer10ms[i]
        if lgActV[i] < lgVmin[i]
           lgActV[i] := lgVmin[i]

        if lgWntPos==lgActPos
           byState[i] := 40
           
      40:'wait for start command
         IF !xMoveStart[i]
           xMoveDone[i] := true
           byState[i] := 0
}}              
dat

b0                      long $1
b1                      long $2
b2                      long $4
b3                      long $8
b4                      long $10
b5                      long $20
b6                      long $40
b7                      long $80

b8                      long $100
b9                      long $200
b10                     long $400
b11                     long $800
b12                     long $1000
b13                     long $2000
b14                     long $4000
b15                     long $8000

b16                     long $10000
b17                     long $20000
b18                     long $40000
b19                     long $80000
b20                     long $100000
b21                     long $200000
b22                     long $400000
b23                     long $800000

b24                     long $1000000
b25                     long $2000000
b26                     long $4000000
b27                     long $8000000
b28                     long $10000000
b29                     long $20000000
b30                     long $40000000
b31                     long $80000000

hubM1_4Ctrl             long $7000

hubM1WntPos             long $7060
hubM2WntPos             long $7064
hubM3WntPos             long $7068
hubM4WntPos             long $706C

hubM1ActPos             long $7020
hubM2ActPos             long $7024
hubM3ActPos             long $7028
hubM4ActPos             long $702C

hubM1MaxCount           long $7040
hubM2MaxCount           long $7044
hubM3MaxCount           long $7048
hubM4MaxCount           long $704C
      