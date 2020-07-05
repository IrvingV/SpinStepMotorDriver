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

  long M1AutoMode
  long M2AutoMode
  long M3AutoMode
  long M4AutoMode

  long M1Enabled
  long M2Enabled
  long M3Enabled
  long M4Enabled

  long M1WntPos
  long M2WntPos
  long M3WntPos
  long M4WntPos

  long M1JogForward
  long M2JogForward
  long M3JogForward
  long M4JogForward

  long M1JogBackward
  long M2JogBackward
  long M3JogBackward
  long M4JogBackward
  byte i
 
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
  if b==true
    pc.Str(string("TRUE "))
  elseif b==false
    pc.Str(string("FALSE"))
  else
    pc.Str(string("?????"))  

PUB Main

  pc.Start(PC_BAUD)
  stpmtr.StartM1_M4(0)
  motn.start
  stpmtr.SetMaxCount(1,4)
  stpmtr.SetMaxCount(2,4)
  stpmtr.SetMaxCount(3,4)
  stpmtr.SetMaxCount(4,4)
  M1AutoMode := false
  M2AutoMode := false
  M3AutoMode := false
  M4AutoMode := false
  M1Enabled := false
  M2Enabled := false
  M3Enabled := false
  M4Enabled := false
  
  pc.clear
  repeat
      waitcnt(cnt + 10000)
      PrnXyStr(1, 2, string("stepmotor execute time and taskcounter "))
      PrnXyDec(50, 2, stpmtr.ExecuteTime)
      PrnXyDec(60, 2, stpmtr.LoopCount / 2)

      PrnXyStr(0, 5, string(" 1=auto/manual  2=disabled/enabled   3=homepos   4=wantedpos   5=fast   6=slow   7=JogFw   8=JogBw"))

'                            01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
      PrnXyStr(0, 9, string("          mode      enabled   direction pulsing   act.pos   wnt.pos   At.pos    act.count max.count"))
      i:=1
      PrnXyBool(10, i+11, M1AutoMode)
      PrnXyBool(20, i+11, M1Enabled)
      PrnXyBool(30, i+11, stpmtr.Direction(i))
      PrnXyBool(40, i+11, stpmtr.Pulsing(i))
      PrnXyDec (50, i+11, stpmtr.ActualPosition(i))
      PrnXyDec (60, i+11, stpmtr.WantedPosition(i))
      PrnXyBool(70, i+11, stpmtr.AtPosition(i))
      PrnXyDec (80, i+11, stpmtr.ActualCount(i))
      PrnXyDec (90, i+11, stpmtr.MaxCount(i))




    xKeyPressed := pc.RxCheck

    if xKeyPressed == "1"
      stpmtr.AutoMode(1,NOT M1AutoMode)
      M1AutoMode := NOT M1AutoMode
    if xKeyPressed == "q"
      stpmtr.AutoMode(2,NOT M2AutoMode)
      M2AutoMode := NOT M2AutoMode
    if xKeyPressed == "a"
      stpmtr.AutoMode(3,NOT M3AutoMode)
      M3AutoMode := NOT M3AutoMode
    if xKeyPressed == "z"
      stpmtr.AutoMode(4,NOT M4AutoMode)
      M4AutoMode := NOT M4AutoMode

    if xKeyPressed == "2"
      stpmtr.Enable(1,NOT M1Enabled)
      M1Enabled := NOT M1Enabled
    if xKeyPressed == "w"
      stpmtr.Enable(2,NOT M2Enabled)
      M2Enabled := NOT M2Enabled
    if xKeyPressed == "s"
      stpmtr.Enable(3,NOT M3Enabled)
      M3Enabled := NOT M3Enabled
    if xKeyPressed == "x"
      stpmtr.Enable(4,NOT M4Enabled)
      M4Enabled := NOT M4Enabled
   
    if xKeyPressed == "3"
        stpmtr.SetHomePosition(1,1111)
    if xKeyPressed == "e"
        stpmtr.SetHomePosition(2,2222)
    if xKeyPressed == "d"
        stpmtr.SetHomePosition(3,3333)
    if xKeyPressed == "c"
        stpmtr.SetHomePosition(4,4444)

    if xKeyPressed == "4"
        stpmtr.SetWantedPosition(1,1234)
        M1WntPos := 1234
    if xKeyPressed == "r"
        stpmtr.SetWantedPosition(2,2345)
        M2WntPos := 2345
    if xKeyPressed == "f"
        stpmtr.SetWantedPosition(3,3456)
        M3WntPos := 3456
    if xKeyPressed == "v"
        stpmtr.SetWantedPosition(4,4567)
        M4WntPos := 4567
   
    if xKeyPressed == "5"
        stpmtr.SetMaxCount(1,2)
    if xKeyPressed == "t"
        stpmtr.SetMaxCount(2,2)
    if xKeyPressed == "g"
        stpmtr.SetMaxCount(3,2)
    if xKeyPressed == "b"
        stpmtr.SetMaxCount(4,2)

    if xKeyPressed == "6"
        stpmtr.SetMaxCount(1,4)
    if xKeyPressed == "y"
        stpmtr.SetMaxCount(2,4)
    if xKeyPressed == "h"
        stpmtr.SetMaxCount(3,4)
    if xKeyPressed == "n"
        stpmtr.SetMaxCount(4,4)

    if xKeyPressed == "7"
        stpmtr.JogForward(1,not M1JogForward)
        M1JogForward := not M1JogForward

    if xKeyPressed == "8"
        stpmtr.JogBackward(1,not M1JogBackward)
        M1JogBackward := not M1JogBackward

DAT

 

  