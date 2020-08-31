'**********************************************************
'***  File name   : StepMotor_Main.spin                 ***
'***  Author      : Irving Verijdt                      ***
'**********************************************************

CON
  _clkmode      = xtal1 + pll16x     
  _xinfreq      = 5_000_000


OBJ
  comm          : "RwHubMemory"
  stpmtr        : "M1_4StepPulsCtrl"
  mtn           : "M1_4MotionCtrl"

PUB start 
  comm    .start
  stpmtr  .start
  mtn     .start
                