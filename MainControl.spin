'**********************************************************
'***  File name   : MainControl.spin                    ***
'***  Author      : Irving Verijdt                      ***
'**********************************************************

CON
  _clkmode      = xtal1 + pll16x     
  _xinfreq      = 5_000_000
   
OBJ
  usbcomm       : "RwHubMemory"
  ''stpmtr        : "M1_4StepPulsCtrl"
  ''motn          : "M1_4MotionCtrl"

PUB Start

  usbcomm.start
  ''stpmtr.start(0)
  ''motn.start(0)
  