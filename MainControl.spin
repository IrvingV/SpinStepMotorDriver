'***********************************************************
'***  Raspberry pi / Propellor / ioboard / servo control ***
'***********************************************************
'*  Author: Irving Verijdt   *
'*****************************

   
OBJ
  motn          : "M1_4MotionCtrl"

VAR

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
 


PUB Start


  motn.Start

  ''motn.Set_lgVmax(1,8000)
  ''motn.Set_lgVmin(1,10)
  ''motn.Set_lgAcc(1,100000)
  ''motn.Set_lgDec(1,100000)
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

  