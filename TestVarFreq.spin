'**************************************************************************
'*  <<<<< : variable frquency test                                     *
'*  Author: Irving Verijdt                                                *
'**************************************************************************

'**************************************************************************
VAR
'**************************************************************************
long    cogon, cog

'**************************************************************************
PUB start(recordptr) : okay
'**************************************************************************
  stop
  okay := cogon := (cog := cognew( @entry, recordptr )) > 0

'**************************************************************************
PUB stop
'**************************************************************************
  if cogon~
     cogstop(cog)

'**************************************************************************
DAT                     
'**************************************************************************
                        org     0              
entry                   mov     dira, #$FF
                       ''mov     outa,          #$00
                        ''wrlong  cnt,    ramlgTaskTime

'**************************************************************************
'***  Prepare timer mainloop
'**************************************************************************
                        mov     lgTime, cnt
                        add     lgTime, #9

'**************************************************************************
'***  Main loop, Wait for counterlgTaskTime
'**************************************************************************
mainloop                waitcnt lgTime, lgTaskTime
                        add     lgTest,         #1

'**************************************************************************
'*** time stamp before
'**************************************************************************
 
                        ''test    outa, #1   wz  
 ''                 mov     outa, #1
                 xor     outa, #1
            ''if_z        mov     outa, #0
 
 
                        ''mov     lgStartTime,  cnt

                        wrlong  lgTime,    ramlgTaskTime
 
                        ''mov     lgTime, cnt
                        ''add     lgTime, #9      '  correct  ????????????????

                        jmp     #mainloop


'**************************************************************************
'***  Constants                                                         ***
'**************************************************************************
''lgTaskTime              long 50000  '500 usec

lgTaskTime              long 500000 '5  msec

''lgTaskTime              long 500000 '50 msec

'**************************************************************************
'***  I/O                                                               ***
'**************************************************************************
''Pin0                    long %0000_0001
''Pin1                    long %0000_0010
''DDR                     long %0000_0011     '0 = pin as Input, 1 = pin as Output'
    
                                              
'**************************************************************************
'***  HUB RAM adressen                                                  ***
'**************************************************************************
ramlgTaskTime           long $7000        


'**************************************************************************
'***  Local var                                                         ***
'**************************************************************************

'///// Execution control var \\\\\
lgStartTime             res
lgEndTime               res
lgTime                  res
lgTest                  res        