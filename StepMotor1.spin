'**************************************************************************
'*  <<<<< : StepMotor 1                                                   *
'*  Author: Irving Verijdt                                                *
'**************************************************************************


VAR

long    cogon, cog


PUB start(recordptr) : okay

  stop
  okay := cogon := (cog := cognew( @entry, recordptr )) > 0


PUB stop

  if cogon~
     cogstop(cog)


DAT
                        org     0              

'***  Initialize Cog
entry                   mov     dira,           byDataDirectionReg
                        mov     outa,           #$00
                        wrlong  cnt,            ramlgTaskTime

'***  Prepare timer mainloop
                        mov     lgTime,         cnt
                        add     lgTime,         #9

'***  Main loop
mainloop                waitcnt lgTime,         TASKTIME
                        add     lgScanCounter,  #1

                        xor     outa,           xoMotorStepPuls
                        add     ramlgPosition,  #1

                        wrlong  lgTime,    ramlgTaskTime
                        wrlong  lgTime,    ramlgTaskTime

                        jmp     #mainloop
'***  Constants
TASKTIME                long 5000  '500 usec

'***  Harware settings
xoMotorDirection        long %0000_0001         'Pin0
xoMotorStepPuls         long %0000_0010         'Pin1
byDataDirectionReg      long %0000_0011         '0 = Input, 1 = Output'
    
'***  HUB RAM adressen
ramlgTaskTime           long $7000
ramlgPosition           long $7004
ramlgScanCounter        long $7008                


'**************************************************************************
'***  Local var                                                         ***
'**************************************************************************

'///// Execution control var \\\\\
lgTime                  res
lgScanCounter           res        