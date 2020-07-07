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

  long AutoMode[5]

  long Enabled[5]

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
  byte j
 
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
  AutoMode[1] := false
  AutoMode[2] := false
  AutoMode[3] := false
  AutoMode[4] := false
  Enabled[1] := false
  Enabled[2] := false
  Enabled[3] := false
  Enabled[4] := false
  
  pc.clear
  repeat
      waitcnt(cnt + 10000)
      PrnXyStr(1, 2, string("stepmotor execute time and taskcounter "))
      PrnXyDec(50, 2, stpmtr.ExecuteTime)
      PrnXyDec(60, 2, stpmtr.LoopCount / 2)

      PrnXyStr(0, 5, string(" 1=auto/manual  2=disabled/enabled   3=homepos   4=wantedpos   5=fast   6=slow   7=JogFw   8=JogBw"))

'                            01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890'
      PrnXyStr(0, 9, string("          mode      enabled   direction pulsing   act.pos   wnt.pos   At.pos    act.count max.count"))
      repeat i from 1 to 4
        PrnXyBool(10, i+11, AutoMode[i])
        PrnXyBool(20, i+11, Enabled[i])
        PrnXyBool(30, i+11, stpmtr.Direction(i))
        PrnXyBool(40, i+11, stpmtr.Pulsing(i))
        PrnXyDec (50, i+11, stpmtr.ActualPosition(i))
        PrnXyDec (60, i+11, stpmtr.WantedPosition(i))
        PrnXyBool(70, i+11, stpmtr.AtPosition(i))
        PrnXyDec (80, i+11, stpmtr.ActualCount(i))
        PrnXyDec (90, i+11, stpmtr.MaxCount(i))




    xKeyPressed := pc.RxCheck

    if xKeyPressed == "1"
      stpmtr.AutoMode(1,NOT AutoMode[1])
      AutoMode[1] := NOT AutoMode[1]
    if xKeyPressed == "q"
      stpmtr.AutoMode(2,NOT AutoMode[2])
      AutoMode[2] := NOT AutoMode[2]
    if xKeyPressed == "a"
      stpmtr.AutoMode(3,NOT AutoMode[3])
      AutoMode[3] := NOT AutoMode[3]
    if xKeyPressed == "z"
      stpmtr.AutoMode(4,NOT AutoMode)
      AutoMode[4] := NOT AutoMode[4]

    if xKeyPressed == "2"
      stpmtr.Enable(1,NOT Enabled[1])
      Enabled[1] := NOT Enabled[1]
    if xKeyPressed == "w"
      stpmtr.Enable(2,NOT Enabled[2])
      Enabled[2] := NOT Enabled[2]
    if xKeyPressed == "s"
      stpmtr.Enable(3,NOT Enabled[3])
      Enabled[3] := NOT Enabled[3]
    if xKeyPressed == "x"
      stpmtr.Enable(4,NOT Enabled[4])
      Enabled[4] := NOT Enabled[4]
   
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
    if xKeyPressed == "r"
        stpmtr.SetWantedPosition(2,2345)
    if xKeyPressed == "f"
        stpmtr.SetWantedPosition(3,3456)
    if xKeyPressed == "v"
        stpmtr.SetWantedPosition(4,4567)
   
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
    if xKeyPressed == "u"
        stpmtr.JogForward(2,not M2JogForward)
        M2JogForward := not M2JogForward
    if xKeyPressed == "j"
        stpmtr.JogForward(3,not M3JogForward)
        M3JogForward := not M1JogForward
    if xKeyPressed == "m"
        stpmtr.JogForward(4,not M4JogForward)
        M4JogForward := not M4JogForward

    if xKeyPressed == "8"
        stpmtr.JogBackward(1,not M1JogBackward)
        M1JogBackward := not M1JogBackward
    if xKeyPressed == "i"
        stpmtr.JogBackward(2,not M2JogBackward)
        M2JogBackward := not M2JogBackward
    if xKeyPressed == "k"
        stpmtr.JogBackward(3,not M3JogBackward)
        M3JogBackward := not M3JogBackward
    if xKeyPressed == ","
        stpmtr.JogBackward(4,not M4JogBackward)
        M4JogBackward := not M4JogBackward

DAT

 

  