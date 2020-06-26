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
 
PUB StartM1_M4(x)
   
  ''Stp
  byCogID1 := cognew (@entry,0)

PUB Stp
'******
  if byCogID1 > -1
    cogstop(byCogID1)



PUB SetRun(x, Run)
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

PUB SetSpeedFast (x, Fast)
  if Fast
    case x
      1: long[hubMaxCountM1] := 2
      2: long[hubMaxCountM2] := 2
      3: long[hubMaxCountM3] := 2
      4: long[hubMaxCountM4] := 2
  else
    case x
      1: long[hubMaxCountM1] := 4  
      2: long[hubMaxCountM2] := 4  
      3: long[hubMaxCountM3] := 4  
      4: long[hubMaxCountM4] := 4  

PUB SetDir (x, Dir)
  if Dir
    case x
      1: long[hubCtrlM1_4] := long[hubCtrlM1_4] | bit0  
      2: long[hubCtrlM1_4] := long[hubCtrlM1_4] | bit8
      3: long[hubCtrlM1_4] := long[hubCtrlM1_4] | bit16
      4: long[hubCtrlM1_4] := long[hubCtrlM1_4] | bit24
  else
    case x
      1: long[hubCtrlM1_4] := long[hubCtrlM1_4] & !bit0  
      2: long[hubCtrlM1_4] := long[hubCtrlM1_4] & !bit8
      3: long[hubCtrlM1_4] := long[hubCtrlM1_4] & !bit16
      4: long[hubCtrlM1_4] := long[hubCtrlM1_4] & !bit24



PUB M_SetPosition (Pos)
  lgActualPos1 := Pos                               
  
PUB Running(x)
  case x
    1: return long[hubStatM1_4] & bit1 == bit1  
    2: return long[hubStatM1_4] & bit9 == bit9 
    3: return long[hubStatM1_4] & bit17 == bit17 
    4: return long[hubStatM1_4] & bit25 == bit25 


PUB ActualPosition(x)
  case x
    1: return long[hubActPosM1]
    2: return long[hubActPosM2]
    3: return long[hubActPosM3]
    4: return long[hubActPosM4]

PUB ExecuteTime
  return long[hubExecTime]

PUB ActualCount (x)
  case x
    1: return long[hubActCountM1]
    2: return long[hubActCountM2]
    3: return long[hubActCountM3]
    4: return long[hubActCountM4]


DAT
    
'Initialisation
Entry                   mov     dira,           #%11111111
                        mov     outa,           #%00000000

                        mov     lgCtrlM1_4,     #0
                        wrlong  lgCtrlM1_4,     hubCtrlM1_4
                        
                        mov     lgTime, cnt
                        add     lgTime, #9
'Wait for next sample
mainloop                waitcnt lgTime,         lgDelay

                        mov     lgStartTime,    cnt
'Read Parameters
                        rdlong  lgCtrlM1_4,     hubCtrlM1_4
                        rdlong  lgMaxCountM1,   hubMaxCountM1
                        rdlong  lgMaxCountM2,   hubMaxCountM2
                        rdlong  lgMaxCountM3,   hubMaxCountM3
                        rdlong  lgMaxCountM4,   hubMaxCountM4
                        rdlong  lgHomePosM1,    hubHomePosM1
                        rdlong  lgHomePosM2,    hubHomePosM2
                        rdlong  lgHomePosM3,    hubHomePosM3
                        rdlong  lgHomePosM4,    hubHomePosM4

'Write motor directions outputs
                        test    lgCtrlM1_4,     bit0    wz
                        muxnz   outa,           bit0                        

                        test    lgCtrlM1_4,     bit8    wz
                        muxnz   outa,           bit2                        

                        test    lgCtrlM1_4,     bit16   wz
                        muxnz   outa,           bit4                        

                        test    lgCtrlM1_4,     bit24   wz
                        muxnz   outa,           bit6
                                                
'Write motor step puls outputs
M1                      test    lgCtrlM1_4,     bit1 wz
                        muxnz   lgStatM1_4,     bit1 
              if_nz     jmp     #M1Stop
                        cmp     lgActCountM1,   #0 wz    
M1Puls                  muxz    outa,           bit1
                        add     lgActCountM1,   #1                      
                        jmp     #M2                 
M1Stop                  andn    outa,           bit1
                        mov     lgActCountM1,   #0


M2                      test    lgCtrlM1_4,     bit9 wz
                        muxnz   lgStatM1_4,     bit9 
              if_nz     jmp     #M2Stop
                        cmp     lgActCountM2,   #0 wz    
M2Puls                  muxz    outa,           bit3
                        add     lgActCountM2,   #1                      
                        jmp     #M3                 
M2Stop                  andn    outa,           bit3
                        mov     lgActCountM2,   #0

M3                      test    lgCtrlM1_4,     bit17 wz
                        muxnz   lgStatM1_4,     bit17 
              if_nz     jmp     #M3Stop
                        cmp     lgActCountM3,   #0 wz    
M3Puls                  muxz    outa,           bit5        
                        add     lgActCountM3,   #1                      
                        jmp     #M4                 
M3Stop                  andn    outa,           bit5
                        mov     lgActCountM3,   #0

M4                      test    lgCtrlM1_4,     bit25 wz
                        muxnz   lgStatM1_4,     bit25 
              if_nz     jmp     #M4Stop
                        cmp     lgActCountM4,   #0 wz    
M4PulsOn                muxz    outa,           bit7
                        add     lgActCountM4,   #1                      
                        jmp     #Mend                 
M4Stop                  andn    outa,           bit7
                        mov     lgActCountM4,   #0


Mend
'Check actual counters
                        cmp     lgActCountM1,   lgMaxCountM1 wc
              if_nc     mov     lgActCountM1,   #0              
                        cmp     lgActCountM2,   lgMaxCountM2 wc
              if_nc     mov     lgActCountM2,   #0              
                        cmp     lgActCountM3,   lgMaxCountM3 wc
              if_nc     mov     lgActCountM3,   #0              
                        cmp     lgActCountM4,   lgMaxCountM4 wc
              if_nc     mov     lgActCountM4,   #0              







'Write Values   
                        wrlong  lgStatM1_4,     hubStatM1_4
                        wrlong  lgActCountM1,   hubActCountM1
                        wrlong  lgActCountM2,   hubActCountM2
                        wrlong  lgActCountM3,   hubActCountM3
                        wrlong  lgActCountM4,   hubActCountM4
                        
                        wrlong  lgActPosM1,     hubActPosM1
                        wrlong  lgActPosM2,     hubActPosM2
                        wrlong  lgActPosM3,     hubActPosM3
                        wrlong  lgActPosM4,     hubActPosM4

'Calculate executing time   
                        mov     lgEndTime,      cnt
                        mov     lgExecTime,     lgEndTime
                        sub     lgExecTime,     lgStartTime
                        wrlong  lgExecTime,     hubExecTime

                        jmp     #mainloop                        
 
''lgDelay                 long 50000000           '0,5 sec     f =   1 Hz(maxcount = 2) 
''lgDelay                 long 5000000            '0,05 sec    f =  10 Hz
''lgDelay                 long 500000             '0,005 sec   f = 100 Hz  
''lgDelay                 long 50000              '0,0005 sec  f =   1 kHz  
lgDelay                 long 5000               '0,00005 sec f =  10 kHz
                                                'Maxcount =2 f =10   kHz
                                                'Maxcount =3 f = 6.6 kHz
                                                'Maxcount =4 f = 5   kHz
                                                'Maxcount =5 f = 2   kHz
                                                        

bit0                    long $1
bit1                    long $2
bit2                    long $4
bit3                    long $8
bit4                    long $10
bit5                    long $20
bit6                    long $40
bit7                    long $80

bit8                    long $100
bit9                    long $200

bit16                   long $10000
bit17                   long $20000

bit24                   long $1000000
bit25                   long $2000000

hubCtrlM1_4             long $7000
hubStatM1_4             long $7004

hubHomePosM1            long $7010
hubHomePosM2            long $7014
hubHomePosM3            long $7018
hubHomePosM4            long $701C

hubActPosM1             long $7020
hubActPosM2             long $7024
hubActPosM3             long $7028
hubActPosM4             long $702C

hubActCountM1           long $7030
hubActCountM2           long $7034
hubActCountM3           long $7038
hubActCountM4           long $703C

hubMaxCountM1           long $7040
hubMaxCountM2           long $7044
hubMaxCountM3           long $7048
hubMaxCountM4           long $704C

hubExecTime             long $7050

lgCtrlM1_4              res
lgStatM1_4              res

lgHomePosM1             res
lgHomePosM2             res
lgHomePosM3             res
lgHomePosM4             res

lgActPosM1              res
lgActPosM2              res
lgActPosM3              res
lgActPosM4              res

lgActCountM1            res
lgActCountM2            res
lgActCountM3            res
lgActCountM4            res

lgMaxCountM1            res
lgMaxCountM2            res
lgMaxCountM3            res
lgMaxCountM4            res

lgExecTime              res

lgTime                  res
lgStartTime             res
lgEndTime               res
