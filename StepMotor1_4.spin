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
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b1  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b9
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b17
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b25
  else
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b1  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b9
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b17
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b25

PUB SetSpeedFast (x, Fast)
  if Fast
    case x
      1: long[hubM1MaxCount] := 2
      2: long[hubM2MaxCount] := 2
      3: long[hubM3MaxCount] := 2
      4: long[hubM4MaxCount] := 2
  else
    case x
      1: long[hubM1MaxCount] := 4  
      2: long[hubM2MaxCount] := 4  
      3: long[hubM3MaxCount] := 4  
      4: long[hubM4MaxCount] := 4  

PUB SetDir (x, Dir)
  if Dir
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b0  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b8
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b16
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b24
  else
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b0  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b8
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b16
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b24



PUB M_SetPosition (Pos)
  lgActualPos1 := Pos                               
  
PUB ExecuteTime
  return long[hubExecTime]

PUB Running(x)
  case x
    1: return long[hubM1_4Stat] & b1 == b1  
    2: return long[hubM1_4Stat] & b9 == b9 
    3: return long[hubM1_4Stat] & b17 == b17 
    4: return long[hubM1_4Stat] & b25 == b25 


PUB ActualPosition(x)
  case x
    1: return long[hubM1ActPos]
    2: return long[hubM2ActPos]
    3: return long[hubM3ActPos]
    4: return long[hubM4ActPos]

PUB ActualCount (x)
  case x
    1: return long[hubM1ActCount]
    2: return long[hubM2ActCount]
    3: return long[hubM3ActCount]
    4: return long[hubM4ActCount]

PUB MaxCount (x)
  case x
    1: return long[hubM1MaxCount]
    2: return long[hubM2MaxCount]
    3: return long[hubM3MaxCount]
    4: return long[hubM4MaxCount]

DAT
    
'Initialisation
Entry                   mov     dira,           #%11111111
                        mov     outa,           #%00000000

                        mov     lgM1_4Ctrl,     #0
                        wrlong  lgM1_4Ctrl,     hubM1_4Ctrl
                        mov     lgM1ActPos,     #0
                        mov     lgM2ActPos,     #0
                        mov     lgM3ActPos,     #0
                        mov     lgM4ActPos,     #0
                        
                        mov     lgTime, cnt
                        add     lgTime, #9
'Wait for next sample
mainloop                waitcnt lgTime,         lgDelay

                        mov     lgStartTime,    cnt
'Read Parameters
                        rdlong  lgM1_4Ctrl,     hubM1_4Ctrl
                        rdlong  lgM1MaxCount,   hubM1MaxCount
                        rdlong  lgM2MaxCount,   hubM2MaxCount
                        rdlong  lgM3MaxCount,   hubM3MaxCount
                        rdlong  lgM4MaxCount,   hubM4MaxCount
                        rdlong  lgM1HomePos,    hubM1HomePos
                        rdlong  lgM2HomePos,    hubM2HomePos
                        rdlong  lgM3HomePos,    hubM3HomePos
                        rdlong  lgM4HomePos,    hubM4HomePos

'Write motor directions outputs
                        test    lgM1_4Ctrl,     b0    wz
                        muxnz   outa,           b0                        

                        test    lgM1_4Ctrl,     b8    wz
                        muxnz   outa,           b2                        

                        test    lgM1_4Ctrl,     b16   wz
                        muxnz   outa,           b4                        

                        test    lgM1_4Ctrl,     b24   wz
                        muxnz   outa,           b6
                                                
'Write motor step puls outputs
M1                      test    lgM1_4Ctrl,     b1 wz
                        muxnz   lgM1_4Stat,     b1 
              if_nz     jmp     #M1Stop
                        cmp     lgM1ActCount,   #0 wz    
M1Puls                  muxz    outa,           b1
              if_z      add     lgM1ActPos,     #1
                        add     lgM1ActCount,   #1                      
                        jmp     #M2                 
M1Stop                  andn    outa,           b1
                        mov     lgM1ActCount,   #0


M2                      test    lgM1_4Ctrl,     b9 wz
                        muxnz   lgM1_4Stat,     b9 
              if_nz     jmp     #M2Stop
                        cmp     lgM2ActCount,   #0 wz    
M2Puls                  muxz    outa,           b3
                        add     lgM2ActCount,   #1                      
                        jmp     #M3                 
M2Stop                  andn    outa,           b3
                        mov     lgM2ActCount,   #0

M3                      test    lgM1_4Ctrl,     b17 wz
                        muxnz   lgM1_4Stat,     b17 
              if_nz     jmp     #M3Stop
                        cmp     lgM3ActCount,   #0 wz    
M3Puls                  muxz    outa,           b5        
                        add     lgM3ActCount,   #1                      
                        jmp     #M4                 
M3Stop                  andn    outa,           b5
                        mov     lgM3ActCount,   #0

M4                      test    lgM1_4Ctrl,     b25 wz
                        muxnz   lgM1_4Stat,     b25 
              if_nz     jmp     #M4Stop
                        cmp     lgM4ActCount,   #0 wz    
M4PulsOn                muxz    outa,           b7
                        add     lgM4ActCount,   #1                      
                        jmp     #Mend                 
M4Stop                  andn    outa,           b7
                        mov     lgM4ActCount,   #0


Mend
'Check actual counters
                        cmp     lgM1ActCount,   lgM1MaxCount wc
              if_nc     mov     lgM1ActCount,   #0              
                        cmp     lgM2ActCount,   lgM2MaxCount wc
              if_nc     mov     lgM2ActCount,   #0              
                        cmp     lgM3ActCount,   lgM3MaxCount wc
              if_nc     mov     lgM3ActCount,   #0              
                        cmp     lgM4ActCount,   lgM4MaxCount wc
              if_nc     mov     lgM4ActCount,   #0              







'Write Values   
                        wrlong  lgM1_4Stat,     hubM1_4Stat
                        wrlong  lgM1ActCount,   hubM1ActCount
                        wrlong  lgM2ActCount,   hubM2ActCount
                        wrlong  lgM3ActCount,   hubM3ActCount
                        wrlong  lgM4ActCount,   hubM4ActCount
                        
                        wrlong  lgM1ActPos,     hubM1ActPos
                        wrlong  lgM2ActPos,     hubM2ActPos
                        wrlong  lgM3ActPos,     hubM3ActPos
                        wrlong  lgM4ActPos,     hubM4ActPos

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
lgDelay                 long 5000_000               '0,00005 sec f =  10 kHz
                                                'Maxcount =2 f =10   kHz
                                                'Maxcount =3 f = 6.6 kHz
                                                'Maxcount =4 f = 5   kHz
                                                'Maxcount =5 f = 2   kHz
                                                        

b0                    long $1
b1                    long $2
b2                    long $4
b3                    long $8
b4                    long $10
b5                    long $20
b6                    long $40
b7                    long $80

b8                    long $100
b9                    long $200
b10                    long $200

b16                   long $10000
b17                   long $20000

b24                   long $1000000
b25                   long $2000000

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

lgM1_4Ctrl              res
lgM1_4Stat              res

lgM1HomePos             res
lgM2HomePos             res
lgM3HomePos             res
lgM4HomePos             res

lgM1ActPos              res
lgM2ActPos              res
lgM3ActPos              res
lgM4ActPos              res

lgM1ActCount            res
lgM2ActCount            res
lgM3ActCount            res
lgM4ActCount            res

lgM1MaxCount            res
lgM2MaxCount            res
lgM3MaxCount            res
lgM4MaxCount            res

lgExecTime              res
lgTime                  res
lgStartTime             res
lgEndTime               res