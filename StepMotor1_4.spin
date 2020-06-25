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
      1: long[$7000] := long[$7000] | $2  
      2: long[$7000] := long[$7000] | $200
      3: long[$7000] := long[$7000] | $20000
      4: long[$7000] := long[$7000] | $2000000
  else
    case x
      1: long[$7000] := long[$7000] & !$2  
      2: long[$7000] := long[$7000] & !$200
      3: long[$7000] := long[$7000] & !$20000
      4: long[$7000] := long[$7000] & !$2000000

PUB SetRunFast (Fast)
  if Fast
    woMaxPulsCount1                  := 10
  else
    woMaxPulsCount1                  := 100  

PUB SetDir (x, Dir)
  if Dir
    case x
      1: long[hubCtrlM1_m4] := long[hubCtrlM1_m4] | $1  
      2: long[hubCtrlM1_m4] := long[hubCtrlM1_m4] | $100
      3: long[hubCtrlM1_m4] := long[hubCtrlM1_m4] | $10000
      4: long[hubCtrlM1_m4] := long[hubCtrlM1_m4] | $1000000
  else
    case x
      1: long[hubCtrlM1_m4] := long[hubCtrlM1_m4] & !$1  
      2: long[hubCtrlM1_m4] := long[hubCtrlM1_m4] & !$100
      3: long[hubCtrlM1_m4] := long[hubCtrlM1_m4] & !$10000
      4: long[hubCtrlM1_m4] := long[hubCtrlM1_m4] & !$1000000



PUB M_SetPosition (Pos)
  lgActualPos1 := Pos                               
  
PUB Running(x)
  return xRun1

PUB M_ActualPosition
  return lgActualPos1

PUB M_ExecuteTime
  return lgExecuteTime1

PUB M_FirstPin
  return byPinDirection1

PUB M_SecondPin
  return byPinStepPuls1
DAT
    
Entry                   mov     dira,   #%11111111
                        mov     outa,   #%00000000

                        mov     Time, cnt
                        add     Time, #9
'***************************************************************************                       
mainloop                waitcnt Time,           lgDelay
                        rdlong  lgCtrlM1_M4,    hubCtrlM1_m4

                        test    lgCtrlM1_M4,    bit0    wz
              if_z      andn    outa,           bit0                        
              if_nz     or      outa,           bit0                        

                        test    lgCtrlM1_M4,    bit8    wz
              if_z      andn    outa,           bit2                        
              if_nz     or      outa,           bit2

                        test    lgCtrlM1_M4,    bit16    wz
              if_z      andn    outa,           bit4                        
              if_nz     or      outa,           bit4


              jmp       #mainloop                        




 
lgDelay                 long 10000

bit0                    long $1
bit1                    long $2
bit2                    long $4
bit3                    long $8

bit4                    long $10
bit5                    long $20
bit6                    long $40
bit7                    long $80

bit8                    long $100

bit16                   long $10000

hubCtrlM1_m4         long $7000
hubHomePosM1         long $7008
hubHomePosM2         long $700C
hubHomePosM3         long $7010
hubHomePosM4         long $7018


hubStatM1_M4         long $7100
hubActPosM1          long $7108
hubActPosM2          long $710C
hubActPosM3          long $7110
hubActPosM4          long $7118


lgCtrlM1_M4                     res
lgHomePosM1                     res
Time      