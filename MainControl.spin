'***********************************************************
'***  Raspberry pi / Propellor / ioboard / servo control ***
'***********************************************************
'*  Author: Irving Verijdt   *
'*****************************

CON                                                                           
  PC_BAUD       = 115_200
   
OBJ
  pc            : "Parallax Serial Terminal"
  stpmtr        : "M1_4StepPulsCtrl"
  ''motn          : "M1_4MotionCtrl"

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
 
PRI PrnXyDec(x,y,s,d)
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
  ''motn.Start

  ''motn.Set_lgVmax(1,100)
  ''motn.Set_lgVmin(1,10)
  ''motn.Set_lgAcc(1,100)
  ''motn.Set_lgDec(1,100)
  
  ''motn.Set_lgVmax(2,100)
  ''motn.Set_lgVmin(2,10)
  ''motn.Set_lgAcc(2,100)
  ''motn.Set_lgDec(2,100)

  ''motn.Set_lgVmax(3,100)
  ''motn.Set_lgVmin(3,10)
  ''motn.Set_lgAcc(3,100)
  ''motn.Set_lgDec(3,100)


  stpmtr.SetMaxCount(1,10)
  stpmtr.SetMaxCount(2,10)
  stpmtr.SetMaxCount(3,10)
  stpmtr.SetMaxCount(4,44444)
  
  repeat
    waitcnt(cnt + 1000000)
    
     ''PrnXyDec (1, 1, string("error "),motn.Get_c)
      i:=2
    ''repeat i from 1 to 4

        PrnXyStr( 2,1,string("Commands 1) 0=manual 1=auto"))
        PrnXyStr(15,2,string("2) 0=disabled 1= enabled"))
        PrnXyStr(15,3,string("4) jog+"))
        PrnXyStr(15,4,string("5) jog-"))
        PrnXyStr(15,5,string("7) set home position 10"))
        PrnXyStr(15,6,string("9) set wanted position 100"))

       PrnXyBool ( 1, 6+i*4, string("1.auto mode = "),stpmtr.Automode(i))
        PrnXyBool (31, 6+i*4, string("2 enabled = "),stpmtr.Enabled(i))
        PrnXyBool (61, 6+i*4, string("wnt=actPos = "),stpmtr.AtPosition(i))
        PrnXyBool ( 1, 7+i*4, string("pulsing = "),stpmtr.Pulsing(i))
        PrnXyBool (31, 7+i*4, string("direction = "),stpmtr.Direction(i))
        PrnXyDec  ( 1, 8+i*4, string("actual pos = "),stpmtr.ActualPosition(i))
        PrnXyDec  (31, 8+i*4, string("wanted pos = "),stpmtr.WantedPosition(i))
        PrnXyDec  (61, 8+i*4, string("MaxCount = "),stpmtr.MaxCount(i))
{{   
        PrnXyDec (10, 3, string("error  "),motn.Get_woError)
        PrnXyDec (30, 3, string("state  "),motn.Get_byState(i))
        PrnXyDec (50, 3, string("type   "),motn.Get_byMoveType(i))
        
        PrnXyDec (10, 5, string("actPos "),motn.Get_lgActPos(i))
        PrnXyDec (30, 5, string("wntPos "),motn.Get_lgWntPos(i))
        PrnXyDec (50, 5, string("PosErr "),motn.Get_lgAbsDiff(i))
        
        PrnXyDec (10, 7, string("X1     "),motn.Get_lgX1(i))
        PrnXyDec (30, 7, string("X2     "),motn.Get_lgX2(i))
        PrnXyDec (50, 7, string("reldist"),motn.Get_lgRelDist(i))
        
        PrnXyDec (10, 9, string("acc10ms"),motn.Get_lgAccPer10ms(i))
        PrnXyDec (30, 9, string("v calcd"),motn.Get_lgVcalced(i))
        PrnXyDec (50, 9, string("v act  "),motn.Get_lgActV(i))
}}  
    xKeyPressed := pc.RxCheck
{{
    if xKeyPressed == "1"
       motn.StartRelMove(i,999)
        
    if xKeyPressed == "r"
       motn.Reset(i)

    if xKeyPressed == "3"
       motn.StartRelMove(i,9)
 
}}
       ' Test StepPulsControl
    if xKeyPressed == "1"
       if stpmtr.Automode(i)
          stpmtr.SetAutoMode(i,false)
       else
          stpmtr.SetAutomode(i,true)   
       
    if xKeyPressed == "2"
       if stpmtr.Enabled(i)
          stpmtr.SetEnable(i,false)
       else
          stpmtr.SetEnable(i,true)   
        
    if xKeyPressed == "4"
       if stpmtr.JogForward(i)
          stpmtr.SetJogForward(i,false)
       else
          stpmtr.SetJogBackward(i,false)
          stpmtr.SetJogForward(i,true)
             
    if xKeyPressed == "5"
       if stpmtr.JogBackward(i)
          stpmtr.SetJogBackward(i,false)
       else
          stpmtr.SetJogForward(i,false)
          stpmtr.SetJogBackward(i,true)
    if xKeyPressed == "7"
         stpmtr.SetHomePosition(i,10)
    if xKeyPressed == "9"
         stpmtr.SetWantedPosition(i,100)
{{   
    if xKeyPressed == "r"
       motn.Reset(1)

    if xKeyPressed == "3"
       motn.StartRelMove(3,9)

}}  