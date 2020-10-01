'**********************************************************
'***  File name   : MainControl.spin                    ***
'***  Author      : Irving Verijdt                      ***
'**********************************************************

CON
  _clkmode      = xtal1 + pll16x     
  _xinfreq      = 5_000_000
   
OBJ
  usbcomm       : "RwHubMemory"
  motn          : "M1_4MotionCtrl"

PUB Start

  usbcomm.start(14,15)          'start(RxdPin,TxdPin) 115200 Bd, 8, N, 1
  ''stpmtr.start
  motn.start
  