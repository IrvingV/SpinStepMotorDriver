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

  byte byProfileGeneratotorState

  
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
  motn.start
  
  motn.SetSpeed(1,300)
  motn.SetAcceleration(1,100)
  motn.SetDeceleration(1,100)
  motn.SetRelMove(1,2000)
  AutoMode[1] := false
  AutoMode[2] := false
  AutoMode[3] := false
  AutoMode[4] := false
  Enabled[1] := false
  Enabled[2] := false
  Enabled[3] := false
  Enabled[4] := false
  M1JogForward := false
  M2JogForward := false
  M3JogForward := false
  M4JogForward := false
  M1JogBackward := false
  M2JogBackward := false
  M3JogBackward := false
  M4JogBackward := false
  
  pc.clear
  repeat
      waitcnt(cnt + 20000)
      repeat i from 1 to 4
        PrnXyBool(10, i+11, AutoMode[i])
        PrnXyBool(20, i+11, Enabled[i])
        PrnXyBool(30, i+11, motn.Direction(i))
        PrnXyBool(40, i+11, motn.Pulsing(i))
        PrnXyDec (50, i+11, motn.ActualPosition(i))
        PrnXyDec (60, i+11, motn.WantedPosition(i))
        PrnXyBool(70, i+11, motn.AtPosition(i))
        PrnXyDec (80, i+11, motn.ActualCount(i))
        PrnXyDec (90, i+11, motn.MaxCount(i))




    xKeyPressed := pc.RxCheck

    if xKeyPressed == "1"
      AutoMode[1] := motn.AutoMode(1,NOT AutoMode[1])
    if xKeyPressed == "q"
      AutoMode[2] := motn.AutoMode(2,NOT AutoMode[2])
    if xKeyPressed == "a"
      AutoMode[3] := motn.AutoMode(3,NOT AutoMode[3])
    if xKeyPressed == "z"
      AutoMode[4] := motn.AutoMode(4,NOT AutoMode[4])

    if xKeyPressed == "2"
      Enabled[1] := motn.Enable(1,NOT Enabled[1])
    if xKeyPressed == "w"
      Enabled[2] := motn.Enable(2,NOT Enabled[2])
    if xKeyPressed == "s"
      Enabled[3] := motn.Enable(3,NOT Enabled[3])
    if xKeyPressed == "x"
      Enabled[4] := motn.Enable(4,NOT Enabled[4])
   
    if xKeyPressed == "3"
        motn.SetHomePosition(1,1111)
    if xKeyPressed == "e"
        motn.SetHomePosition(2,2222)
    if xKeyPressed == "d"
        motn.SetHomePosition(3,3333)
    if xKeyPressed == "c"
        motn.SetHomePosition(4,4444)

    if xKeyPressed == "4"
        motn.SetWantedPosition(1,1234)
    if xKeyPressed == "r"
        motn.SetWantedPosition(2,2345)
    if xKeyPressed == "f"
        motn.SetWantedPosition(3,3456)
    if xKeyPressed == "v"
        motn.SetWantedPosition(4,4567)
   
    if xKeyPressed == "5"
        motn.SetMaxCount(1,2)
    if xKeyPressed == "t"
        motn.SetMaxCount(2,2)
    if xKeyPressed == "g"
        motn.SetMaxCount(3,2)
    if xKeyPressed == "b"
        motn.SetMaxCount(4,2)

    if xKeyPressed == "6"
        motn.SetMaxCount(1,4)
    if xKeyPressed == "y"
        motn.SetMaxCount(2,4)
    if xKeyPressed == "h"
        motn.SetMaxCount(3,4)
    if xKeyPressed == "n"
        motn.SetMaxCount(4,4)

    if xKeyPressed == "7"
        motn.JogForward(1,not M1JogForward)
        M1JogForward := not M1JogForward
    if xKeyPressed == "u"
        motn.JogForward(2,not M2JogForward)
        M2JogForward := not M2JogForward
    if xKeyPressed == "j"
        motn.JogForward(3,not M3JogForward)
        M3JogForward := not M3JogForward
    if xKeyPressed == "m"
        motn.JogForward(4,not M4JogForward)
        M4JogForward := not M4JogForward

    if xKeyPressed == "8"
        motn.JogBackward(1,not M1JogBackward)
        M1JogBackward := not M1JogBackward
    if xKeyPressed == "i"
        motn.JogBackward(2,not M2JogBackward)
        M2JogBackward := not M2JogBackward
    if xKeyPressed == "k"
        motn.JogBackward(3,not M3JogBackward)
        M3JogBackward := not M3JogBackward
    if xKeyPressed == ","
        motn.JogBackward(4,not M4JogBackward)
        M4JogBackward := not M4JogBackward

DAT

 

  