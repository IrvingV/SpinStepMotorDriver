 
'**************************************************************************
'*  Step Motor Pulscontrol                                                *
'*                                                                        *
'*  Hardware                                                              *
'*  Author: Irving Verijdt                                                *
'**************************************************************************

VAR

long    cogon, cog

long    DataDirection


PUB start(recordptr) : okay
  stop
  okay := cogon := (cog := cognew( @entry, recordptr )) > 0


PUB stop

  if cogon~
     cogstop(cog)


DAT
                        org     0              

'***  Initialize Cog
entry                   mov     dira,           #$0F
                        mov     outa,           #$00

'***  Prepare timer mainloop
                        mov     lgTime,         cnt
                        add     lgTime,         #9

'***  Main loop
mainloop                waitcnt lgTime,         TASKTIME
                        mov     lgStartTime,    cnt
                                     
                        add     lgScanCounter,  #1

'***  get data
                        rdlong  lgPulsControl   hubPulsControl
                        rdlong  lgMaxCountM1    hubMaxCountM1
                        rdlong  lgMaxCountM2    hubMaxCountM2

'***  M1 set direction
              z         test    lgPulsControl   bit0
              if_z      andn    outa,           xoDirectionM1    
              if_nz     or      outa            xoDirectionM1
                        
'***  M2 Set direction
              z         test    lgPulsControl   bit8
              if_z      andn    outa,           xoDirectionM2     
              if_nz     or      outa            xoDirectionM2

'***  M1 Step Puls Control
M1            z         test    lgPulsControl   bit1
              if_z      jmp     #stepM1
              


                        jmp     #M2
              z         cmp     lgCountM1,      #0
              if             


              z         cmp     lgPulsControl   bit1
              if_z      and     outa,           xoDirectionM1     


 
              if_z      or     outa,            xoStepPulsM1
              if_z      add    lgPositionM1,    #1



                        

'***  put data
                        wrlong  lgScanCounter,  ramlgTaskTime
                        wrlong  ramlgPosition1, ramlgTaskTime

                        jmp     #mainloop
'***  Constants
TASKTIME                long 500  '50 usec

'***  Harware settings
xoDirectionM1           long %0000_0001         'Pin0
xoStepPulsM1            long %0000_0010         'Pin1
xoDirectionM2           long %0000_0100         'Pin2
xoStepPulsM2            long %0000_1000         'Pin3
    
'***  global
hublgTaskTime           long $7000
hublgPosition           long $7004
hublgScanCounter        long $7008                


ram

'**************************************************************************
'***  Local var                                                         ***
'**************************************************************************

lgTime                  res
lgScanCounter           res
lgPulsControl           res
  