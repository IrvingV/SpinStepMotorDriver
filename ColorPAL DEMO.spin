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
  pc            : "Parallax Serial Terminal"
  motn          : "M1_4MotionCtrl"
  stpmtr        : "M1_4StepPulsCtrl"

VAR
  byte xKeyPressed
  ''long IoCtrl
  long abc
 
PRI PrnXyDec(x,y,d)
  pc.Position(x,y)
  pc.Str(string("> "))
  pc.dec(d)
  pc.Str(string(" <"))

PRI PrnXyStr(x,y,str)
  pc.Position(x,y)
  pc.Str(str)
    
PRI PrnXyBool(x,y,b)
  pc.Position(x,y)
  if b==-1
    pc.Str(string("TRUE "))
  elseif b==0
    pc.Str(string("FALSE"))
  else
    pc.Str(string("?????"))  

PUB Main

  pc.Start(PC_BAUD)
  stpmtr.StartM1_M4(0)
  motn.start
  stpmtr.SetSpeedFast(1,false)
  stpmtr.SetSpeedFast(2,false)
  stpmtr.SetSpeedFast(3,false)
  stpmtr.SetSpeedFast(4,false)
  pc.clear
  repeat
      waitcnt(cnt + 10000)
      PrnXyStr(1, 2, string("stepmotor execute time and taskcounter "))
      PrnXyDec(50, 2, stpmtr.ExecuteTime)
      PrnXyDec(60, 2, stpmtr.LoopCount / 2)

      PrnXyBool(10, 4, stpmtr.Running(1))
      PrnXyBool(20, 4, stpmtr.Direction(1))
      PrnXyDec (30, 4, stpmtr.ActualPosition(1))
      ''PrnXyDec(40, 4, stpmtr.ActualCount(1))
      ''PrnXyDec(50, 4, stpmtr.MaxCount(1))
   
      PrnXyBool(10, 5, stpmtr.Running(2))
      PrnXyBool(20, 5, stpmtr.Direction(2))
      PrnXyDec (30, 5, stpmtr.ActualPosition(2))
      ''PrnXyDec(40, 5, stpmtr.ActualCount(2))
      ''PrnXyDec(50, 5, stpmtr.MaxCount(2))

      PrnXyBool(10, 6, stpmtr.Running(3))
      PrnXyBool(20, 6, stpmtr.Direction(3))
      PrnXyDec (30, 6, stpmtr.ActualPosition(3))
      ''PrnXyDec(40, 6, stpmtr.ActualCount(3))
      ''PrnXyDec(50, 6, stpmtr.MaxCount(3))

      PrnXyBool(10, 7, stpmtr.Running(4))
      PrnXyBool(20, 7, stpmtr.Direction(4))
      PrnXyDec (30, 7, stpmtr.ActualPosition(4))
      ''PrnXyDec(40, 7, stpmtr.ActualCount(4))
      ''PrnXyDec(50, 7, stpmtr.MaxCount(4))


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
      if stpmtr.Running(1)
        stpmtr.SetSpeedFast(1,false)
        stpmtr.SetRun(1,true)
      else
        stpmtr.SetRun(1,false)
    if xKeyPressed == "e"
      if stpmtr.Running(2)
        stpmtr.SetSpeedFast(2,false)
        stpmtr.SetRun(2,true)
      else
        stpmtr.SetRun(2,false)
    if xKeyPressed == "d"
      if stpmtr.Running(3)
        stpmtr.SetSpeedFast(3,false)
        stpmtr.SetRun(3,true)
      else
        stpmtr.SetRun(3,false)
    if xKeyPressed == "c"
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

DAT

 

  