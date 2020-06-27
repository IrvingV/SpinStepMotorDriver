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
  pc                :"Parallax Serial Terminal"
  motn              :"Motion"
  stpmtr            :"StepMotor1_4"

VAR
  byte xKeyPressed
  ''long IoCtrl
 
PUB Main

  pc.Start(PC_BAUD)
  stpmtr.StartM1_M4(0)
 
  repeat
    waitcnt(cnt + 50000)
      pc.home
      pc.Str(string("Execution time"))
      pc.dec(stpmtr.ExecuteTime)
      pc.NewLine

      pc.Str(string("Motor, state, position, actcount, maxcount"))
      pc.NewLine

      pc.Str(string("  1      "))
      pc.dec(stpmtr.Running(1))
      pc.Position(20, 2)
      pc.dec(stpmtr.ActualPosition(1))
      pc.Position(30, 2)
      pc.dec(stpmtr.ActualCount(1))
      pc.Position(40, 2)
      pc.dec(stpmtr.MaxCount(1))
      pc.Position(50, 2)
      pc.dec(stpmtr.ActualCount(1))
      pc.NewLine

      pc.Str(string("  2      "))
      pc.dec(stpmtr.Running(2))
      pc.Position(20,3)
      pc.dec(stpmtr.ActualPosition(2))
      pc.Position(30,3)
      pc.dec(stpmtr.ActualCount(2))
      pc.Position(40,3)
      pc.dec(stpmtr.MaxCount(2))
      pc.Position(50,3)
      pc.dec(stpmtr.ActualCount(2))
      pc.NewLine

      pc.Str(string("  3      "))
      pc.dec(stpmtr.Running(3))
      pc.Position(20,4)
      pc.dec(stpmtr.ActualPosition(3))
      pc.Position(20,4)
      pc.dec(stpmtr.ActualCount(3))
      pc.Position(30,4)
      pc.dec(stpmtr.MaxCount(3))
      pc.Position(40,4)
      pc.dec(stpmtr.ActualCount(3))
      pc.NewLine

      pc.Str(string("  4      "))
      pc.dec(stpmtr.Running(3))
      pc.Position(20,5)
      pc.dec(stpmtr.ActualPosition(4))
      pc.Position(20,5)
      pc.dec(stpmtr.ActualCount(4))
      pc.Position(30,5)
      pc.dec(stpmtr.MaxCount(4))
      pc.Position(40,5)
      pc.dec(stpmtr.ActualCount(4))
      pc.NewLine

    xKeyPressed := pc.RxCheck

    if xKeyPressed == "1"
      stpmtr.SetDir(1, false)
    if xKeyPressed == "q"
      stpmtr.SetDir(2, false)
    if xKeyPressed == "a"
      stpmtr.SetDir(3, false)
    if xKeyPressed == "z"
      stpmtr.SetDir(4, false)

    if xKeyPressed == "2"
      stpmtr.SetDir(1,true)
    if xKeyPressed == "w"
      stpmtr.SetDir(2,true)
    if xKeyPressed == "s"
      stpmtr.SetDir(3,true)
    if xKeyPressed == "x"
      stpmtr.SetDir(4,true)

    if xKeyPressed == "3"
      pc.Dec(stpmtr.Running(1))
      if stpmtr.Running(1)
        stpmtr.SetSpeedFast(1,false)
        stpmtr.SetRun(1,true)
      else
        stpmtr.SetRun(1,false)
    if xKeyPressed == "e"
      pc.Dec(stpmtr.Running(2))
      if stpmtr.Running(2)
        stpmtr.SetSpeedFast(2,false)
        stpmtr.SetRun(2,true)
      else
        stpmtr.SetRun(2,false)
    if xKeyPressed == "d"
      pc.Dec(stpmtr.Running(3))
      if stpmtr.Running(3)
        stpmtr.SetSpeedFast(3,false)
        stpmtr.SetRun(3,true)
      else
        stpmtr.SetRun(3,false)
    if xKeyPressed == "c"
      pc.Dec(stpmtr.Running(4))
      if stpmtr.Running(4)
        stpmtr.SetSpeedFast(4,false)
        stpmtr.SetRun(4,true)
      else
        stpmtr.SetRun(4,false)
   
    if xKeyPressed == "4"
        stpmtr.SetSpeedFast(1,true)
    if xKeyPressed == "r"
        stpmtr.SetSpeedFast(2,true)
    if xKeyPressed == "f"
        stpmtr.SetSpeedFast(3,true)
    if xKeyPressed == "v"
        stpmtr.SetSpeedFast(4,true)
   
    if xKeyPressed == "5"
        stpmtr.SetSpeedFast(1,false)
    if xKeyPressed == "t"
        stpmtr.SetSpeedFast(2,false)
    if xKeyPressed == "g"
        stpmtr.SetSpeedFast(3,false)
    if xKeyPressed == "b"
        stpmtr.SetSpeedFast(4,false)

    if xKeyPressed == "6"
      pc.Str(string("***   6 pressed M1 ExecTime, ActCount : "))
      pc.dec(stpmtr.ExecuteTime)
      pc.Str(string("  "))
      pc.dec(stpmtr.ActualCount(1))
  
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

 

  