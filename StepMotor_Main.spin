
CON

  _clkmode      = xtal1 + pll16x     
  _xinfreq      = 5_000_000


VAR

  
  
OBJ

  usbcomm       : "RwHubMemory"
  ''mc            : "MainControl"  
  stpmtr        : "M1_4StepPulsCtrl"
  ''motn          : "M1_4MotionCtrl"


PUB start 

  usbcomm.Start

  ''mc.Start
  stpmtr.Start
  ''motn.Start


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

                