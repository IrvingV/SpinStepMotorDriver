'***********************************************************
'***  Raspberry pi / Propellor / ioboard / servo control ***
'***********************************************************
'*  Author: Irving Verijdt   *
'*****************************

CON                                                                           
  'Setup the system clock settings
  _clkmode      = xtal1 + pll16x     
  _xinfreq      = 5_000_000
  
  PC_BAUD       = 115_200
   
OBJ
  ''tst             :"TestVarFreq"
  pc                :"Parallax Serial Terminal"
  stepm1            :"StepMotor_SPIN"
  stepm2            :"StepMotor_SPIN"
  stepm3            :"StepMotor_SPIN"


VAR

  byte xKeyPressed
  ''long IoCtrl 
 
PUB Main

  pc.Start(PC_BAUD)               
  stepm1.Start(0,1)
  stepm2.Start(2,3)
  stepm3.Start(4,5)
 
  repeat
    waitcnt(cnt + 50000) 

    xKeyPressed := pc.CharIn

    if xKeyPressed == "?"
      pc.Str(string("=========    Propellor HUB RAM Read and Write    =========="))
      pc.NewLine

    if xKeyPressed == "1"
      pc.Str(string("***   1 pressed M1 forward"))
      pc.NewLine
      stepm1.M_SetDirection(false)
    if xKeyPressed == "q"
      pc.Str(string("***   q pressed M2 forward"))
      pc.NewLine
      stepm2.M_SetDirection(false)
    if xKeyPressed == "a"
      pc.Str(string("***   a pressed M3 forward"))
      pc.NewLine
      stepm3.M_SetDirection(false)

    if xKeyPressed == "2"
      pc.Str(string("***   2 pressed M1 backward"))
      pc.NewLine
      stepm1.M_SetDirection(true)
    if xKeyPressed == "w"
      pc.Str(string("***   w pressed M2 backward"))
      pc.NewLine
      stepm2.M_SetDirection(true)
    if xKeyPressed == "s"
      pc.Str(string("***   s pressed M3 backward"))
      pc.NewLine
      stepm3.M_SetDirection(true)

    if xKeyPressed == "3"
      if stepm1.M_running
        pc.Str(string("***   3 pressed M stopping"))
        stepm1.M_Stop
      else
         pc.Str(string("***   3 pressed M starting"))
         stepm1.M_Run
      pc.NewLine
   
    if xKeyPressed == "4"
      pc.Str(string("***   4 pressed M1 goes fast"))
      pc.NewLine
        stepm1.M_RunFast(true)

    if xKeyPressed == "5"
      pc.Str(string("***   5 pressed M1 goes slow"))
      pc.NewLine
        stepm1.M_RunFast(false)

    if xKeyPressed == "6"
      pc.Str(string("***   6 pressed M1 execute time : "))
      pc.dec(stepm1.M_ExecuteTime)
      pc.NewLine
    
    if xKeyPressed == "7"
      pc.Str(string("***   6 pressed M1 actual position : "))
      pc.dec(stepm1.M_ActualPosition)
      pc.NewLine
    
      
      
      'pc.Str(string("0 "))
      'pc.dec(long[$3104])        ' Message Start Received
      'pc.Str(string(" "))
      'pc.dec(long[$3108])        ' Message Stop Received
      'pc.Str(string(" "))
      'pc.hex(byte[$310C],2)
      'pc.NewLine               

      'pc.Str(string("1 "))
      'pc.hex(byte[$3118], 2)      ''telegram number
      'pc.Str(string("  "))
      'pc.hex(byte[$3110], 2)      ''received bytes
      'pc.Str(string(" "))
      'pc.hex(byte[$3111], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3112], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3113], 2)
      'pc.Str(string("  "))
      'pc.hex(byte[$3114], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3115], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3116], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3117], 2)
      'pc.NewLine               

  '    pc.Str(string("2     "))
  '   pc.hex(byte[$3120], 2)      ''sended bytes
  '   pc.Str(string(" "))
   '  pc.hex(byte[$3121], 2)
   '  pc.Str(string(" "))
   '  pc.hex(byte[$3122], 2)
   '  pc.Str(string(" "))
   '  pc.hex(byte[$3123], 2)
      'pc.Str(string("  "))
      'pc.hex(byte[$3124], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3125], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3126], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3127], 2)
      'pc.NewLine               
      'pc.NewLine               

      'pc.Str(string("Lego Nxt         Cog:"))
      'pc.dec(long[$3000])        ' Cog running
      'pc.NewLine               

      'pc.Str(string("0 "))
      'pc.dec(long[$3004])        ' Message Start Received
      'pc.Str(string(" "))
      'pc.dec(long[$3008])        ' Message Stop Received
      'pc.Str(string(" "))
      'pc.hex(byte[$300C],2)
      'pc.NewLine               

      'pc.Str(string("1 "))
      'pc.hex(byte[$3018], 2)      ''telegram number
      'pc.Str(string("  "))
      'pc.hex(byte[$3010], 2)      ''received bytes
      'pc.Str(string(" "))
      'pc.hex(byte[$3011], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3012], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3013], 2)
      'pc.Str(string("  "))
      'pc.hex(byte[$3014], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3015], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3016], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3017], 2)
      'pc.NewLine               

      'pc.Str(string("2     "))
      'pc.hex(byte[$3020], 2)      ''sended bytes
      'pc.Str(string(" "))
      'pc.hex(byte[$3021], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3022], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3023], 2)
      'pc.Str(string("  "))
      'pc.hex(byte[$3024], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3025], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3026], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3027], 2)
      'pc.NewLine               
      'pc.NewLine               

      'pc.Str(string("IOprint          Cog:"))
      'pc.dec(long[$3200])        ' Cog running
      'pc.NewLine               

      'pc.Str(string("0 "))
      'pc.dec(long[$3204])        ' Message Start Received
      'pc.Str(string(" "))
      'pc.dec(long[$3208])        ' Message Stop Received
      'pc.Str(string(" "))
      'pc.hex(byte[$320C],2)
      'pc.NewLine               

      ''pc.Str(string("1     "))
      'pc.hex(byte[$3210], 2)      ''received bytes
      'pc.Str(string(" "))
      'pc.hex(byte[$3211], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3212], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3213], 2)
      'pc.Str(string("  "))
      'pc.hex(byte[$3214], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3215], 2)
      'pc.NewLine               

      'pc.Str(string("2     "))
      'pc.hex(byte[$3220], 2)      ''sended bytes
      'pc.Str(string(" "))
      'p'c.hex(byte[$3221], 2)
      'pc.Str(string(" "))
      'p'c.hex(byte[$3222], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3223], 2)
      'pc.Str(string("  "))
      'pc.hex(byte[$3224], 2)
      'pc.Str(string(" "))
      'pc.hex(byte[$3225], 2)


     
    'if xKeyPressed >= 48 and xKeyPressed <= 49
     '  pc.Char(xKeyPressed)
 
   


DAT

 

  