'***********************************************************
'***  Raspberry pi / Propellor / ioboard / servo control ***
'***********************************************************
'*  Author: Irving Verijdt   *
'*****************************

CON                                                                           
  ''_clkmode      = xtal1 + pll16x     
  ''_xinfreq      = 5_000_000

  PC_BAUD       = 115_200
   
OBJ
  pc            : "Parallax Serial Terminal"
  stpmtr        : "M1_4StepPulsCtrl"
  motn          : "M1_4MotionCtrl"

VAR
  byte xKeyPressed

  long lgWntPos[5]

{{
  long AutoMode[5]

  long Enabled[5]


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
}}
  
  byte i,j
  long alive
  byte xAuto[5]
  byte xEnable[5]
  byte xFw[5]
  byte xBw[5]
 
PRI PrnXyDec(x,y,s,d)
  pc.Position(x,y)
  pc.Str(s)
  pc.Str(string("> "))
  pc.dec(d)
  pc.Str(string(" <     "))

PRI PrnXyHex(x,y,s,d)
  pc.Position(x,y)
  pc.Str(s)
  pc.Str(string("> "))
  pc.dec(d)
  pc.Str(string(" <"))

PRI PrnXyStr(x,y,str)
  pc.Position(x,y)
  pc.Str(str)
    
PRI PrnXyBool(x,y,s,b)
  pc.Position(x,y)
  pc.Str(s)
  if b==true
    pc.Str(string("TRUE "))
  elseif b==false
    pc.Str(string("FALSE"))
  else
    pc.Str(string("?????"))  

PUB Main

  pc.Start(PC_BAUD)
  stpmtr.Start
  motn.Start

  motn.Set_lgVmax(1,100)
  motn.Set_lgVmin(1,10)
  motn.Set_lgAcc(1,100)
  motn.Set_lgDec(1,100)
''  motn.Set_Automode(1,true)   
  ''motn.Set_Enable(1,true)   

  
  ''motn.Set_lgVmax(2,100)
  ''motn.Set_lgVmin(2,10)
  ''motn.Set_lgAcc(2,100)
  ''motn.Set_lgDec(2,100)

  ''motn.Set_lgVmax(3,100)
  ''motn.Set_lgVmin(3,10)
  ''motn.Set_lgAcc(3,100)
  ''motn.Set_lgDec(3,100)

{{
  stpmtr.SetMaxCount(1,10)
  stpmtr.SetMaxCount(2,10)
  stpmtr.SetMaxCount(3,10)
  stpmtr.SetMaxCount(4,44444)
}}

 ''         stpmtr.SetAutomode(i,true)   
   ''       stpmtr.SetEnable(i,true)   

  repeat
    waitcnt(cnt + 1000000)
    
     ''PrnXyDec (1, 1, string("error "),motn.Get_c)
      i:=1
    ''repeat i from 1 to 4

        PrnXyStr( 1,1,string("Commands 1) 0=manual 1=auto"))
        PrnXyStr(10,2,string("2) 0=disabled 1= enabled"))
        PrnXyStr(10,3,string("3) jog+"))
        PrnXyStr(10,4,string("4) jog-"))
        PrnXyStr(10,5,string("7) set home position 10"))
        PrnXyStr(10,6,string("9) set wanted position 100"))

        ''PrnXyBool (31, 16+i*4, string("enabled = "),motn.Enabled(i))
        ''PrnXyBool (61, 16+i*4, string("wnt=actPos = "),motn.AtPosition(i))
        ''PrnXyBool ( 1, 17+i*4, string("pulsing = "),motn.Pulsing(i))
        ''PrnXyBool (31, 17+i*4, string("direction = "),motn.Direction(i))
        ''PrnXyDec  ( 1, 18+i*4, string("actual pos = "),motn.ActualPosition(i))
        ''PrnXyDec  (31, 18+i*4, string("wanted pos = "),motn.WantedPosition(i))
        ''PrnXyDec  (61, 18+i*4, string("Speed steps/sec = "),motn.Get_Speed(i))
   
        PrnXyBool ( 20, 8, string("auto mode = "),motn.Get_Automode(i))

        PrnXyDec (10, 10, string("actPos "), motn.Get_hubActPos(i))
        PrnXyDec (30, 10, string("wntPos "), motn.Get_hubWntPos(i))
        PrnXyDec (50, 10, string("PosErr "), motn.Get_hubActPos(i) - motn.Get_hubWntPos(i) )
        PrnXyDec (70, 10, string("PosErr "), motn.Get_lgAbsDiff(i))
        PrnXyDec (90, 10, string("v act  "), motn.Get_Speed(i))

        PrnXyDec (10, 12, string("error  "), motn.Get_woError)
        PrnXyDec (30, 12, string("state  "), motn.Get_byState(i))
        PrnXyDec (50, 12, string("type   "), motn.Get_byMoveType(i))
        
        PrnXyDec (10, 14, string("X1     "), motn.Get_lgX1(i))
        PrnXyDec (30, 14, string("X2     "), motn.Get_lgX2(i))
        PrnXyDec (50, 14, string("reldist"), motn.Get_lgRelDist(i))
        
        PrnXyDec (10, 16, string("acc10ms"), motn.Get_lgAccPer10ms(i))
        PrnXyDec (30, 16, string("v calcd"), motn.Get_lgVcalced(i))
        PrnXyHex (50, 16, string("motn "), motn.cycles)'' motn.counter)
        PrnXyHex (70, 16, string("stpmtr "), clkfreq )''stpmtr.cycles)''motn.readvar)'' motn.counter)
  


    xKeyPressed := pc.RxCheck
  
    if xKeyPressed == "1"
       if xAuto[i]
          motn.Set_AutoMode(i,false)
          xAuto[i] :=false
       else
          motn.Set_Automode(i,true)
          xAuto[i] := true 
       
    if xKeyPressed == "2"
       if xEnable[i]
          motn.Set_Enable(i,false)
          xEnable[i] := false
       else
          motn.Set_Enable(i,true)
          xEnable[i] := true   
      
    if xKeyPressed == "3"
       if xFw[i]
          motn.Set_JogForward(i,false)
          xFw[i]:=false
       else
          motn.Set_JogBackward(i,false)
          motn.Set_JogForward(i,true)
          xFw[i]:=true
             
    if xKeyPressed == "4"
       if xBw[i]   
          motn.Set_JogBackward(i,false)
          xBw[i]:=false
       else
          motn.Set_JogForward(i,false)
          motn.Set_JogBackward(i,true)
          xBw[i]:=true

    if xKeyPressed == "9" and xAuto[i]
       motn.RelMove(i,20000)
        
    if xKeyPressed == "r"
       motn.Reset(i)
  