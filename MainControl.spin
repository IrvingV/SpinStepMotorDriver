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
  stpmtr.Start
  motn.Start

  motn.Set_lgVmax(1,100)
  motn.Set_lgVmin(1,10)
  motn.Set_lgAcc(1,100)
  motn.Set_lgDec(1,100)
''  motn.Set_lgWntPos(1,lgWntPos[1])
  
  repeat
    waitcnt(cnt + 10000000)
    i:=1
    alive++  
    PrnXyDec (10, i, alive)
    ''repeat i from 1 to 4
                              '12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
        PrnXyStr(1, 0, string("         alive     error     enabled   state     actpos    wntpos    x1        x2        relDist   v calced"))
        PrnXyDec (20, i+1, motn.Get_woError)
        PrnXyDec (40, i+1, motn.Get_byState(i))
        PrnXyDec (50, i+1, motn.Get_lgActPos(i))
        PrnXyDec (60, i+1, lgWntPos[i])
        PrnXyDec (70, i+1, motn.Get_lgX1(i))
        PrnXyDec (80, i+1, motn.Get_lgX2(i))
        PrnXyDec (90, i+1, motn.Get_lgRelDist(i))
        PrnXyDec (100, i+1, motn.Get_lgVcalced(i))
  
    xKeyPressed := pc.RxCheck

    if xKeyPressed == "1"
       motn.StartRelMove(1,1000)
        

 

  