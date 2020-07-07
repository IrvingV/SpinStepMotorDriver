' 
'***************************************************************************************************
'*  Step Motor: StepPulsControl (SPIN language)                                                    *
'*  Author    : Irving Verijdt                                                                     *
'*  file      : M1_4StepPulsCtrl.spin                                                              *
'***************************************************************************************************
'*                                  
'* Task time = 50 usec
'*
'* M1,M2,M3,M4  <>  x=1,2,3,4 <>  m=0,2,4,6  <>  n=0,8,16,24                                  
'*                         
'* HW Inputs      -         
'*                                                         
'* HW Outputs     outa          b[m+0]                  StepMotor direction ( backward )
'*                              b[m+1]                  StepMotor Puls   
'*
'* Parameters in  hubM1_4Ctrl.  b[n+2]                  Mx mode auto                             
'*                              b[n+3]                  Mx enable control
'*                              b[n+4]                  Mx Set home position 
'*                              b[n+5]                  Mx Set wanted position 
'*                              b[n+6]                  Mx jog forward 
'*                              b[n+7]                  Mx jog backward 
'*                hubMxMaxCount                         Mx delay next puls 
'*                hubMxWntPos                           Mx wanted position
'*                hubMxHomePos                          Mx home position 
'*
'* Parameters in  lgM1_4Mem .  b[n+0]                  backward signal                             
'*                              b[n+1]                  enable puls control                             
'*
'* Parameters out hubM1_4Stat   b[n+0]                  Mx direction
'*                              b[n+1]                  Mx moving
'*                              b[n+2]                  Mx actual position equals wanted postion
'*                hubMxActPos                           Mx actual position
'*                (hubMxActCount)                       
'*                (hubExecCounter) 
'*                (hubExecTime)
'*
'* Methods        AutoMode(x, Auto)                     Set/reset auto mode
'*                Enable(x, Enab)                       Set/reset enable mode
'*                SetHomePosition(x, Pos)               Set homeposition
'*                SetWantedPosition                     Set wanted position
'*                JogForward                            Set/reset move forward               
'*                JogBackward                           Set/reset move backward 
'*                SetMaxcount                           Set wanted cycle time (speed)
'*
'***************************************************************************************************

CON                                                                           
  _clkmode      = xtal1 + pll16x     
  _xinfreq      = 5_000_000

OBJ

VAR
byte byCogID                 
 
PUB StartM1_M4(x)
  byCogID := cognew (@entry,0)

PUB AutoMode(x, Auto)
  if Auto
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b2  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b10
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b18
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b26
  else
    case x
      1: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b2  
      2: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b10
      3: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b18
      4: long[hubM1_4Ctrl] := long[hubM1_4Ctrl] & !b26

PUB Enable(x, Enab)
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

PUB SetHomePosition (x, Pos)

    case x
      1: long[hubM1HomePos] := Pos
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b4
      2: long[hubM2HomePos] := Pos  
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b12
      3: long[hubM3HomePos] := Pos  
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b20
      4: long[hubM4HomePos] := Pos  
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b28

PUB SetWantedPosition (x, Pos)

    case x
      1: long[hubM1WntPos] := Pos
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b5
      2: long[hubM2WntPos] := Pos  
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b13
      3: long[hubM3WntPos] := Pos  
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b21
      4: long[hubM4WntPos] := Pos  
         long[hubM1_4Ctrl] := long[hubM1_4Ctrl] | b29

PUB JogForward (x, Jog)
  if Jog
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

PUB JogBackward (x, Jog)
  if Jog
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

PUB SetMaxCount (x, count)
    case x
      1: long[hubM1MaxCount] := count
      2: long[hubM2MaxCount] := count
      3: long[hubM3MaxCount] := count
      4: long[hubM4MaxCount] := count


PUB ExecuteTime
  return long[hubExecTime]

PUB LoopCount
  return long[hubExecCounter]

PUB Stat
  return long[hubM1_4Stat]  

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

PUB ActualPosition(x)
  case x
    1: return long[hubM1ActPos]
    2: return long[hubM2ActPos]
    3: return long[hubM3ActPos]
    4: return long[hubM4ActPos]

PUB WantedPosition(x)
  case x
    1: return long[hubM1WntPos]
    2: return long[hubM2WntPos]
    3: return long[hubM3WntPos]
    4: return long[hubM4WntPos]

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
                        mov     lgExecCounter,  #0
                        
                        mov     lgTime, cnt
                        add     lgTime, #9
'Wait for next sample
mainloop                waitcnt lgTime,         lgDelay
                        add     lgExecCounter,  #1
                        mov     lgStartTime,    cnt
'Read Parameters
                        rdlong  lgM1_4Ctrl,     hubM1_4Ctrl
                        rdlong  lgM1MaxCount,   hubM1MaxCount
                        rdlong  lgM2MaxCount,   hubM2MaxCount
                        rdlong  lgM3MaxCount,   hubM3MaxCount
                        rdlong  lgM4MaxCount,   hubM4MaxCount

                        test    lgM1_4Ctrl,     b4 wz
              if_nz     rdlong  lgM1ActPos,     hubM1HomePos 
              if_nz     andn    lgM1_4Ctrl,     b4
              if_nz     wrlong  lgM1_4Ctrl,     hubM1_4Ctrl
                        test    lgM1_4Ctrl,     b12 wz
              if_nz     rdlong  lgM2ActPos,     hubM2HomePos 
              if_nz     andn    lgM1_4Ctrl,     b12
              if_nz     wrlong  lgM1_4Ctrl,     hubM1_4Ctrl
                        test    lgM1_4Ctrl,     b20 wz
              if_nz     rdlong  lgM3ActPos,     hubM3HomePos 
              if_nz     andn    lgM1_4Ctrl,     b20
              if_nz     wrlong  lgM1_4Ctrl,     hubM1_4Ctrl
                        test    lgM1_4Ctrl,     b28 wz
              if_nz     rdlong  lgM4ActPos,     hubM4HomePos 
              if_nz     andn    lgM1_4Ctrl,     b28
              if_nz     wrlong  lgM1_4Ctrl,     hubM1_4Ctrl

                        test    lgM1_4Ctrl,     b5 wz
              if_nz     rdlong  lgM1WntPos,     hubM1WntPos 
              if_nz     andn    lgM1_4Ctrl,     b5
              if_nz     wrlong  lgM1_4Ctrl,     hubM1_4Ctrl
                        test    lgM1_4Ctrl,     b13 wz
              if_nz     rdlong  lgM2WntPos,     hubM2WntPos 
              if_nz     andn    lgM1_4Ctrl,     b13
              if_nz     wrlong  lgM1_4Ctrl,     hubM1_4Ctrl
                        test    lgM1_4Ctrl,     b21 wz
              if_nz     rdlong  lgM3WntPos,     hubM3WntPos 
              if_nz     andn    lgM1_4Ctrl,     b21
              if_nz     wrlong  lgM1_4Ctrl,     hubM1_4Ctrl
                        test    lgM1_4Ctrl,     b29 wz
              if_nz     rdlong  lgM4WntPos,     hubM4WntPos 
              if_nz     andn    lgM1_4Ctrl,     b29
              if_nz     wrlong  lgM1_4Ctrl,     hubM1_4Ctrl

'M1
M1_RS_Dir               andn    lgM1_4Mem,      b0                              'Backward := false
                        test    lgM1_4Ctrl,     b2 wz                           'if auto mode
              if_z      jmp     #M1_DirManual                                   'then is manual
                        
                        cmps    lgM1ActPos,     lgM1WntPos  wc,wz               'Ist > Soll
              if_a      or      lgM1_4Mem,      b0                              'then Backward := true
                        jmp     #M1_RS_Enable

M1_DirManual            test    lgM1_4Ctrl,     b7 wz                           'else if Jog backward
              if_nz     or      lgM1_4Mem,      b0                              'then BackWard := true

M1_RS_Enable            andn    lgM1_4Mem,      b1                              'Enable := false
                        test    lgM1_4Ctrl,     b2 wz                           'if mode manual mode
              if_nz     jmp     #M1_Auto                                        'is manual

M1_Manual               test    lgM1_4Ctrl,     b6 wz                           'then Enable = jogforward or jogbackward
              if_nz     or      lgM1_4Mem,      b1
                        test    lgM1_4Ctrl,     b7 wz
              if_nz     or      lgM1_4Mem,      b1
                        jmp     #M2_RS_Dir

M1_Auto                 cmp     lgM1ActPos,     lgM1WntPos  wz                  'if actual <> wanted position
              if_z      jmp     #M2_RS_Dir                               
                        test    lgM1_4Ctrl,     b3 wz                           'and enabled
                        muxnz   lgM1_4Mem,      b1

'M2
M2_RS_Dir               andn    lgM1_4Mem,      b8                              'Backward := false
                        test    lgM1_4Ctrl,     b10 wz                          'if auto mode
              if_z      jmp     #M2_DirManual                                   'then is manual
                        
                        cmps    lgM2ActPos,     lgM2WntPos  wc,wz               'Ist > Soll
              if_a      or      lgM1_4Mem,      b8                              'then Backward := true
                        jmp     #M2_RS_Enable

M2_DirManual            test    lgM1_4Ctrl,     b15 wz                           'else if Jog backward
              if_nz     or      lgM1_4Mem,      b8                               'then BackWard := true

M2_RS_Enable            andn    lgM1_4Mem,      b9                               'Enable := false
                        test    lgM1_4Ctrl,     b10 wz                           'if mode manual mode
              if_nz     jmp     #M2_Auto                                         'is manual

M2_Manual               test    lgM1_4Ctrl,     b14 wz                           'then Enable = jogforward or jogbackward
              if_nz     or      lgM1_4Mem,      b9
                        test    lgM1_4Ctrl,     b15 wz
              if_nz     or      lgM1_4Mem,      b9
                        jmp     #M3_RS_Dir

M2_Auto                 cmp     lgM2ActPos,     lgM2WntPos  wz                   'if actual <> wanted position
              if_z      jmp     #M3_RS_Dir                               
                        test    lgM1_4Ctrl,     b11 wz                           'and enabled
                        muxnz   lgM1_4Mem,      b9

'M3
M3_RS_Dir               andn    lgM1_4Mem,      b16                              'Backward := false
                        test    lgM1_4Ctrl,     b18 wz                           'if auto mode
              if_z      jmp     #M3_DirManual                                    'then is manual
                        
                        cmps    lgM3ActPos,     lgM3WntPos  wc,wz                'Ist > Soll
              if_a      or      lgM1_4Mem,      b16                              'then Backward := true
                        jmp     #M3_RS_Enable

M3_DirManual            test    lgM1_4Ctrl,     b23 wz                           'else if Jog backward
              if_nz     or      lgM1_4Mem,      b16                              'then BackWard := true

M3_RS_Enable            andn    lgM1_4Mem,      b17                              'Enable := false
                        test    lgM1_4Ctrl,     b18 wz                           'if mode manual mode
              if_nz     jmp     #M3_Auto                                         'is manual

M3_Manual               test    lgM1_4Ctrl,     b22 wz                           'then Enable = jogforward or jogbackward
              if_nz     or      lgM1_4Mem,      b17
                        test    lgM1_4Ctrl,     b23 wz
              if_nz     or      lgM1_4Mem,      b17
                        jmp     #M4_RS_Dir

M3_Auto                 cmp     lgM3ActPos,     lgM3WntPos  wz                  'if actual <> wanted position
              if_z      jmp     #M4_RS_Dir                               
                        test    lgM1_4Ctrl,     b19 wz                           'and enabled
                        muxnz   lgM1_4Mem,      b17

'M4
M4_RS_Dir               andn    lgM1_4Mem,      b24                              'Backward := false
                        test    lgM1_4Ctrl,     b26 wz                           'if auto mode
              if_z      jmp     #M4_DirManual                                   'then is manual
                        
                        cmps    lgM4ActPos,     lgM4WntPos  wc,wz               'Ist > Soll
              if_a      or      lgM1_4Mem,      b24                              'then Backward := true
                        jmp     #M4_RS_Enable

M4_DirManual            test    lgM1_4Ctrl,     b31 wz                           'else if Jog backward
              if_nz     or      lgM1_4Mem,      b24                              'then BackWard := true

M4_RS_Enable            andn    lgM1_4Mem,      b25                              'Enable := false
                        test    lgM1_4Ctrl,     b26 wz                           'if mode manual mode
              if_nz     jmp     #M4_Auto                                        'is manual

M4_Manual               test    lgM1_4Ctrl,     b30 wz                           'then Enable = jogforward or jogbackward
              if_nz     or      lgM1_4Mem,      b25
                        test    lgM1_4Ctrl,     b31 wz
              if_nz     or      lgM1_4Mem,      b25
                        jmp     #DirectionControl

M4_Auto                 cmp     lgM4ActPos,     lgM4WntPos  wz                  'if actual <> wanted position
              if_z      jmp     #DirectionControl                               
                        test    lgM1_4Ctrl,     b27 wz                           'and enabled
                        muxnz   lgM1_4Mem,      b25



DirectionControl        test    lgM1_4Mem,      b0 wz
                        muxnz   outa,           b0                        
                        muxnz   lgM1_4Stat,     b0 

                        test    lgM1_4Mem,      b8 wz
                        muxnz   outa,           b2                        
                        muxnz   lgM1_4Stat,     b8 

                        test    lgM1_4Mem,      b16 wz
                        muxnz   outa,           b4                        
                        muxnz   lgM1_4Stat,     b16 

                        test    lgM1_4Mem,      b24 wz
                        muxnz   outa,           b6
                        muxnz   lgM1_4Stat,     b24 

' Puls control  
'M1
                        test    lgM1_4Mem,      b1 wz                           'if enabled 
                        muxnz   lgM1_4Stat,     b1                              'set status pulsing
              if_z      jmp     #M1Stop
              
                        cmp     lgM1ActCount,   #0 wz    
              if_nz     jmp     #M1PulsOff 
M1PulsOn                or      outa,           b1                              'set puls
                        test    lgM1_4Mem,      b0 wz
              if_z      add     lgM1ActPos,     #1
              if_nz     sub     lgM1ActPos,     #1
                        jmp     #M1ActCount
                        
M1PulsOff               andn    outa,           b1                              'reset puls                               
                                                                                
M1ActCount              add     lgM1ActCount,   #1                      
                        jmp     #M1End                 

M1Stop                  andn    outa,           b1                              'reset puls          
                        mov     lgM1ActCount,   #0

M1End                   test    lgM1_4Ctrl,     b2 wz                           'if manual mode
              if_z      mov     lgM1WntPos,     lgM1ActPos                      'then wntpos = actpos

'M2
                        test    lgM1_4Mem,      b9 wz
                        muxnz   lgM1_4Stat,     b9 
              if_z      jmp     #M2Stop
              
                        cmp     lgM2ActCount,   #0 wz    
              if_nz     jmp     #M2PulsOff 
M2PulsOn                or      outa,           b3
                        test    lgM1_4Mem,      b8    wz
              if_z      add     lgM2ActPos,     #1
              if_nz     sub     lgM2ActPos,     #1
                        jmp     #M2ActCount
                        
M2PulsOff               andn    outa,           b3

M2ActCount              add     lgM2ActCount,   #1                      
                        jmp     #M2End                 

M2Stop                  andn    outa,           b3
                        mov     lgM2ActCount,   #0

M2End                   test    lgM1_4Ctrl,     b10 wz                           'if manual mode
              if_z      mov     lgM2WntPos,     lgM2ActPos                      'then wntpos = actpos

'M3
                        test    lgM1_4Mem,      b17 wz
                        muxnz   lgM1_4Stat,     b17 
              if_z      jmp     #M3Stop
              
                        cmp     lgM3ActCount,   #0 wz    
              if_nz     jmp     #M3PulsOff 
M3PulsOn                or      outa,           b5
                        test    lgM1_4Mem,     b16    wz
              if_z      add     lgM3ActPos,     #1
              if_nz     sub     lgM3ActPos,     #1
                        jmp     #M3ActCount
                        
M3PulsOff               andn    outa,           b5

M3ActCount              add     lgM3ActCount,   #1                      
                        jmp     #M3End                 

M3Stop                  andn    outa,           b5
                        mov     lgM3ActCount,   #0

M3End                   test    lgM1_4Ctrl,     b18 wz                           'if manual mode
              if_z      mov     lgM3WntPos,     lgM3ActPos                      'then wntpos = actpos

'M4
                        test    lgM1_4Mem,      b25 wz
                        muxnz   lgM1_4Stat,     b25 
              if_z      jmp     #M4Stop
              
                        cmp     lgM4ActCount,   #0 wz    
              if_nz     jmp     #M4PulsOff 
M4PulsOn                or      outa,           b7
                        test    lgM1_4Mem,      b24    wz
              if_z      add     lgM4ActPos,     #1
              if_nz     sub     lgM4ActPos,     #1
                        jmp     #M4ActCount
                        
M4PulsOff               andn    outa,           b7

M4ActCount              add     lgM4ActCount,   #1                      
                        jmp     #M4End                 

M4Stop                  andn    outa,           b7
                        mov     lgM4ActCount,   #0

M4End                   test    lgM1_4Ctrl,     b26 wz                           'if manual mode
              if_z      mov     lgM4WntPos,     lgM4ActPos                       'then wntpos = actpos

'Check actual == wanted position
                        cmp     lgM1ActPos,     lgM1WntPos  wz                   ''if actual == wanted position
                        muxz    lgM1_4Stat,     b2 
                        cmp     lgM2ActPos,     lgM2WntPos  wz                   ''if actual == wanted position
                        muxz    lgM1_4Stat,     b10 
                        cmp     lgM3ActPos,     lgM3WntPos  wz                   ''if actual == wanted position
                        muxz    lgM1_4Stat,     b18 
                        cmp     lgM4ActPos,     lgM4WntPos  wz                   ''if actual == wanted position
                        muxz    lgM1_4Stat,     b26 

'CLear actual counter when max is reached
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

                        wrlong  lgM1ActPos,     hubM1ActPos
                        wrlong  lgM2ActPos,     hubM2ActPos
                        wrlong  lgM3ActPos,     hubM3ActPos
                        wrlong  lgM4ActPos,     hubM4ActPos

                        wrlong  lgM1WntPos,     hubM1WntPos
                        wrlong  lgM2WntPos,     hubM2WntPos
                        wrlong  lgM3WntPos,     hubM3WntPos
                        wrlong  lgM4WntPos,     hubM4WntPos

                        wrlong  lgM1ActCount,   hubM1ActCount
                        wrlong  lgM2ActCount,   hubM2ActCount
                        wrlong  lgM3ActCount,   hubM3ActCount
                        wrlong  lgM4ActCount,   hubM4ActCount
                        
                        wrlong  lgExecCounter,  hubExecCounter

'Calculate executing time   
                        mov     lgExecTime,     cnt
                        sub     lgExecTime,     lgStartTime
                        wrlong  lgExecTime,     hubExecTime

                        jmp     #mainloop                        
                                                         
''lgDelay                 long 100_000_000        '1 sec
''lgDelay                 long  5_000_000       '0,05 sec    f =  10 Hz
''lgDelay                 long    500_000       '0,005 sec   f = 100 Hz  
''lgDelay                 long     50_000       '0,0005 sec  f =   1 kHz  
lgDelay                 long      5_000       '0,00005 sec
                                                'Maxcount =2 f = 10   kHz
                                                'Maxcount =3 f =  6.6 kHz
                                                'Maxcount =4 f =  5   kHz
                                                'Maxcount =5 f =  2   kHz
                                                        

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

hubM1WntPos             long $7060
hubM2WntPos             long $7064
hubM3WntPos             long $7068
hubM4WntPos             long $706C

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

lgExecCounter           res

lgM1_4Ctrl              res
lgM1_4Mem               res
lgM1_4Stat              res

lgM1HomePos             res
lgM2HomePos             res
lgM3HomePos             res
lgM4HomePos             res

lgM1ActPos              res
lgM2ActPos              res
lgM3ActPos              res
lgM4ActPos              res

lgM1WntPos              res
lgM2WntPos              res
lgM3WntPos              res
lgM4WntPos              res

lgM1ActCount            res
lgM2ActCount            res
lgM3ActCount            res
lgM4ActCount            res

lgM1MaxCount            res
lgM2MaxCount            res
lgM3MaxCount            res
lgM4MaxCount            res

lgTime                  res

lgExecTime              res
lgStartTime             res