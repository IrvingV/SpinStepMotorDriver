' 
'********************************************************************************
'*  Step Motor Pulscontrol (SPIN language)                                      *
'*  Author: Irving Verijdt                                                      *
'*                                                                              *
'*  Hardware    Inputs:         -                                               *
'*     *                                                         *
'*  Outputs:    * xoForward                                               *
'*              * xoStepPuls                                              *
'*  Hardware                                                              *
'*  Hardware                                                              *


'**************************************************************************

CON                                                                           
  _clkmode      = xtal1 + pll16x     
  _xinfreq      = 5_000_000
  
OBJ

VAR

  long Time
  long lgActualPos
  long lgStartTime
  long lgExecuteTime

  word woPulsCount
  word woMaxPulsCount

  byte byPinDirection
  byte byPinStepPuls
  byte xRun
  byte xDirectionBackward
  byte byCogID
 
PUB Start(PinDir, PinStep)
   
  byPinDirection                  := PinDir
  byPinStepPuls                   := PinStep

  ''Stp
  byCogID := cognew (Loop,0)

PUB Stp
'******
  if byCogID > -1
    cogstop(byCogID)

PRI Loop
  dira[byPinDirection]          := true
  dira[byPinStepPuls]           := true
  
  outa[byPinDirection]          := false            
  outa[byPinStepPuls]           := false

  woMaxPulsCount                := 10
  xDirectionBackward            := false
  woPulsCount                   := 0
  
  repeat     
    waitcnt(1000000+cnt)
    lgStartTime := cnt
    outa[byPinDirection]        := xDirectionBackward

    if xRun

      if woPulsCount == 0
        outa[byPinStepPuls]   := true
        lgActualPos++   
      else           
        outa[byPinStepPuls]   := false

      woPulsCount++
      if woPulsCount > woMaxPulsCount
        woPulsCount             :=0  
        
    else
      outa[byPinStepPuls]   := false
      woPulsCount := 0
      
    lgExecuteTime := cnt - lgStartTime
         

PUB M_Run
  xRun := true

PUB M_Stop
  xRun := false

PUB M_RunFast (Fast)
  if Fast
    woMaxPulsCount                  := 10
  else
    woMaxPulsCount                  := 100  

PUB M_SetDirection (Dir)
  xDirectionBackward := Dir

PUB M_SetPosition (Pos)
  lgActualPos := Pos
  
PUB M_Running
  return xRun

PUB M_ActualPosition
  return lgActualPos

PUB M_ExecuteTime
  return lgExecuteTime

PUB M_FirstPin
  return byPinDirection

PUB M_SecondPin
  return byPinStepPuls    