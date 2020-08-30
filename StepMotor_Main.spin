
CON
  _clkmode      = xtal1 + pll16x     
  _xinfreq      = 5_000_000


OBJ
  usbcomm       : "RwHubMemory"
  ''stpmtr        : "M1_4StepPulsCtrl"
  ''motn          : "M1_4MotionCtrl"

PUB start 
  usbcomm.start
  ''stpmtr.Start(0)
  ''motn.Start(0)
                