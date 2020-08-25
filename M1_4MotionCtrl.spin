' 
'********************************************************************************
'*  Step Motor Pulscontrol (SPIN language)                                      *
'*  Author: Irving Verijdt                                                      *
'*                                                                              *
'********************************************************************************

CON                                                                           
 '' _clkmode      = xtal1 + pll16x     
  ''_xinfreq      = 5_000_000
  
VAR

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
long    i
long    lgX1[5]
long    lgX2[5]
long    lgRelDist[5]
long    lgVcalced[5]
byte    byState[5]
byte    byMoveType[5] '' 1= trapezoidial 2=triangle 3=rectangle
long    lgDx[5]
long    lgActV[5]
long    lgAccPer10ms[5]
word    woError    
long    lgAbsDiff[5]
byte    byAuto[5] 
' Var Out
byte    xMoveDone[5]
long c
long lgTime
long startT
long execT
long seconds, dT, T
long lgExecCounter

PUB Start
  cognew (MotionLoop, 0)

'Getters

PUB Get_hubActPos(x)
  case x
    1: return long[hubM1ActPos]
    2: return long[hubM2ActPos]
    3: return long[hubM3ActPos]
    4: return long[hubM4ActPos]

PUB Get_hubWntPos(x)
  case x
    1: return long[hubM1WntPos]
    2: return long[hubM2WntPos]
    3: return long[hubM3WntPos]
    4: return long[hubM4WntPos]

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

PUB Get_c
  return dT

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
  case x
    1: long[hubM1WantPos] := lgWntPos[1]
    2: long[hubM2WantPos] := lgWntPos[2]                                                                      
    3: long[hubM3WantPos] := lgWntPos[3]
    4: long[hubM4WantPos] := lgWntPos[4]
  
PUB Set_AutoMode(x, Auto)
  if Auto
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b2  
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b6  
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b7
          
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b10
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b14
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b15

      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b18
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b22
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b23

      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b26
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b30
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b31
  else
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b2  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b10
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b18
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b26
  return(Auto)      

PUB Set_Enable(x, Enab)
  if Enab
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b3  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b11
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b19
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b27
  else
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b3  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b11
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b19
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b27
  return(Enab)      

PUB SetHomePosition (x, Pos)

    case x
      1: long[hubM1HomePos] := Pos
      2: long[hubM2HomePos] := Pos  
      3: long[hubM3HomePos] := Pos  
      4: long[hubM4HomePos] := Pos  

PUB SetWantedPosition (x, Pos)

    case x
      1: long[hubM1WantPos] := Pos
      2: long[hubM2WantPos] := Pos  
      3: long[hubM3WantPos] := Pos  
      4: long[hubM4WantPos] := Pos  

PUB Set_JogForward (x, Jog)
  if Jog == true
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b6  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b14
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b22
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b30
  else
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b6  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b14
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b22
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b30

PUB Set_JogBackward (x, Jog)
  if Jog  == true
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b7  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b15
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b23
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b31
  else
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b7  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b15
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b23
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b31

PUB Set_Speed (x, speed)
    case x
      1: long[hubM1MaxCount] := speed/10000
      2: long[hubM2MaxCount] := speed/10000
      3: long[hubM3MaxCount] := speed/10000
      4: long[hubM4MaxCount] := speed/10000

PUB ExecuteTime
  return long[hubExecTime]

PUB Cycles
  return lgExecCounter/100
  
PUB readvar
  return dT
  
PUB Direction(x)
  case x
    1: return long[hubM1_4Stat] & b0 == b0  
    2: return long[hubM1_4Stat] & b8 == b8 
    3: return long[hubM1_4Stat] & b16 == b16 
    4: return long[hubM1_4Stat] & b24 == b24 

PUB Pulsing(x)
  case x
    1: return long[hubM1_4Stat] & b1 == b1  
    2: return long[hubM1_4Stat] & b9 == b9 
    3: return long[hubM1_4Stat] & b17 == b17 
    4: return long[hubM1_4Stat] & b25 == b25 

PUB AtPosition(x)
  case x
    1: return long[hubM1_4Stat] & b2 == b2  
    2: return long[hubM1_4Stat] & b10 == b10 
    3: return long[hubM1_4Stat] & b18 == b18 
    4: return long[hubM1_4Stat] & b26 == b26 

PUB Get_AutoMode(x)
  case x
    1: return long[hubM1_4Ctrl] & b2 == b2  
    2: return long[hubM1_4Ctrl] & b10 == b10 
    3: return long[hubM1_4Ctrl] & b18 == b18 
    4: return long[hubM1_4Ctrl] & b26 == b26 

PUB Enabled(x)
  case x
    1: return long[hubM1_4Ctrl] & b3 == b3  
    2: return long[hubM1_4Ctrl] & b11 == b11 
    3: return long[hubM1_4Ctrl] & b19 == b19 
    4: return long[hubM1_4Ctrl] & b27 == b27 

PUB Get_Speed (x)
  case x
    1: if long[hubM1MaxCount]==0
         return 99999
       else
         return 20000/long[hubM1MaxCount]
    2: if long[hubM2MaxCount]==0
         return 99999
       else
         return 20000/long[hubM2MaxCount]
    3: if long[hubM3MaxCount]==0
         return 99999
       else
         return 20000/long[hubM3MaxCount]
    4: if long[hubM4MaxCount]==0
         return 99999
       else
         return 20000/long[hubM4MaxCount]
  

  case x
    1: return 10000/long[hubM1MaxCount]
    2: return 10000/long[hubM2MaxCount]
    3: return 10000/long[hubM3MaxCount]
    4: return 10000/long[hubM4MaxCount]




PRI MotionLoop

  lgJogSpeed[1]                 := 11
  lgJogSpeed[2]                 := 12
  lgJogSpeed[3]                 := 13
  lgJogSpeed[4]                 := 14

  lgTime :=cnt
  long[$5008]:= 3
  repeat
    waitcnt(lgTime += 1000000*5/6)
    lgExecCounter++
 
    startT:=cnt

    c++
    lgActPos[1]:=long[hubM1Actpos] 
    lgActPos[2]:=long[hubM2Actpos] 
    lgActPos[3]:=long[hubM3Actpos] 
    lgActPos[4]:=long[hubM4Actpos] 
 
    i:=1
    ''repeat i from 1 to 4  

      byAuto[i] := Get_AutoMode(i)
    
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
             1: long[hubM1WantPos] := lgWntPos[1]
             2: long[hubM2WantPos] := lgWntPos[2]                                                                      
             3: long[hubM3WantPos] := lgWntPos[3]
             4: long[hubM4WantPos] := lgWntPos[4]

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
           case i
             1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b3 
             2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b11 
             3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b19  
             4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b27   
         
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
        case i
          1: long[hubM1MaxCount] := 20000/lgActV[1]
          2: long[hubM2MaxCount] := 20000/lgActV[2]    
          3: long[hubM3MaxCount] := 20000/lgActV[3]    
          4: long[hubM4MaxCount] := 20000/lgActV[4]    
      else
        case i
          1: long[hubM1MaxCount] := 20000/lgJogSpeed[1]
          2: long[hubM2MaxCount] := 20000/lgJogSpeed[2]
          3: long[hubM3MaxCount] := 20000/lgJogSpeed[3]
          4: long[hubM4MaxCount] := 20000/lgJogSpeed[4]

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
hubM1_4Stat             long $7004

hubM1HomePos            long $7010
hubM2HomePos            long $7014
hubM3HomePos            long $7018
hubM4HomePos            long $701C

hubM1ActPos             long $7020
hubM2ActPos             long $7024
hubM3ActPos             long $7028
hubM4ActPos             long $702C

hubM1ActCount           long $7030
hubM2ActCount           long $7034
hubM3ActCount           long $7038
hubM4ActCount           long $703C

hubM1MaxCount           long $7040
hubM2MaxCount           long $7044
hubM3MaxCount           long $7048
hubM4MaxCount           long $704C

hubExecTime             long $7050
hubExecCounter          long $7054

hubM1WntPos             long $7060
hubM2WntPos             long $7064
hubM3WntPos             long $7068
hubM4WntPos             long $706C

hubM1WantPos            long $7070
hubM2WantPos            long $7074
hubM3WantPos            long $7078
hubM4WantPos            long $707C

      