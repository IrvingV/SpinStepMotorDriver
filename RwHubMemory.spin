'***********************************************************
'***  Raspberry pi / Propellor / ioboard / servo control ***
'***********************************************************
'*  Author: Irving Verijdt   *
'*****************************

CON                                                                           
  ''_clkmode      = xtal1 + pll16x     
  ''_xinfreq      = 5_000_000

  BaudRate      = 115_200
  CR            = 13
  LF            = 10
  ESC           = 27

OBJ
  pc            : "Parallax Serial Terminal"

VAR
  long Stack[8]
  long    cogon, cog
  byte xKeyPressed
  byte xParseError
  byte byCmd[20]
  byte byPntr
  byte xRL,xRW,xRB,xWL,xWW,xWB
  long lgHubAddress
  long lgValue
  long Digit0
  long Digit1
  long Digit2
  long Digit3
  long Digit4
  long Digit5
  long Digit6
  long Digit7
  byte i
  byte cntEscapes

PUB start
  pc.Start(BaudRate)
  ''waitcnt(clkfreq + cnt)                                'Wait
  ''cognew(Comm,@Stack)
 
''PUB Comm
  ''waitcnt(2*clkfreq + cnt)                                'Wait 2 second for PST
  pc.clear
  pc.char(">")

  repeat 
    xKeyPressed := pc.CharIn
    long[$7800]:= cnt
    if xkeyPressed
      byCmd[byPntr] := xKeyPressed
      byPntr++
      IF byPntr > 17
        CommandTooLong 
        ClearCmd
            
    if xkeypressed == CR
      xParseError := false
      
      if byPntr>1
        ParseCommand

        if xParseError
          parseError

        else

          lgHubAddress := CalcHubAddress
          if xWL
            lgValue := CalcLongValue
            long[lgHubAddress] := lgValue
          if xWW
            lgValue := CalcWordValue
            word[lgHubAddress] := lgValue
          if xWB
            lgValue := CalcByteValue
            byte[lgHubAddress] := lgValue

          if xRL | xWL
            lgValue := long[lgHubAddress]
          if xRW | xWW
            lgValue := word[lgHubAddress]
          if xRB | xWB
            lgValue := byte[lgHubAddress]

          pc.char(byCmd[3])    
          pc.char(byCmd[4])    
          pc.char(byCmd[5])    
          pc.char(byCmd[6])    
          pc.char(" ")

          if xWL | xRL
            Digit0  := lgValue & $F
            lgValue := lgValue >> 4
            Digit1  := lgValue & $F
            lgValue := lgValue >> 4
            Digit2  := lgValue & $F
            lgValue := lgValue >> 4
            Digit3  := lgValue & $F
            lgValue := lgValue >> 4
            Digit4  := lgValue & $F
            lgValue := lgValue >> 4
            Digit5  := lgValue & $F
            lgValue := lgValue >> 4
            Digit6  := lgValue & $F
            lgValue := lgValue >> 4
            Digit7  := lgValue & $F
            pc.char(DecToHex(Digit7))
            pc.char(DecToHex(Digit6))
            pc.char(DecToHex(Digit5))
            pc.char(DecToHex(Digit4))
            pc.char(DecToHex(Digit3))
            pc.char(DecToHex(Digit2))
            pc.char(DecToHex(Digit1))
            pc.char(DecToHex(Digit0))

          if xWW | xRW
            Digit0  := lgValue & $F
            lgValue := lgValue >> 4
            Digit1  := lgValue & $F
            lgValue := lgValue >> 4
            Digit2  := lgValue & $F
            lgValue := lgValue >> 4
            Digit3  := lgValue & $F
            pc.char(DecToHex(Digit3))
            pc.char(DecToHex(Digit2))
            pc.char(DecToHex(Digit1))
            pc.char(DecToHex(Digit0))

          if xWB | xRB
            Digit0  := lgValue & $F
            lgValue := lgValue >> 4
            Digit1  := lgValue & $F
            pc.char(DecToHex(Digit1))
            pc.char(DecToHex(Digit0))

          CRLF    

      ClearCmd
   
    if xkeypressed == ESC
      cntEscapes++
      Escape
      ClearCmd
      
    if xkeypressed == "?"
      Help
      ClearCmd

PUB CalcLongValue

    Digit0 := HexToDec(byCmd[15])
    Digit1 := HexToDec(byCmd[14]) <<  4
    Digit2 := HexToDec(byCmd[13]) <<  8
    Digit3 := HexToDec(byCmd[12]) << 12
    Digit4 := HexToDec(byCmd[11]) << 16 
    Digit5 := HexToDec(byCmd[10]) << 20
    Digit6 := HexToDec(byCmd[9])  << 24
    Digit7 := HexToDec(byCmd[8])  << 28
    return ( Digit7 | Digit6 | Digit5 | Digit4 | Digit3 | Digit2 | Digit1 | Digit0 )

PUB CalcWordValue

    Digit0 := HexToDec(byCmd[11]) 
    Digit1 := HexToDec(byCmd[10]) <<  4 
    Digit2 := HexToDec(byCmd[9])  <<  8
    Digit3 := HexToDec(byCmd[8])  << 12
    return ( Digit3 | Digit2 | Digit1 | Digit0 )

PUB CalcByteValue

    Digit0 := HexToDec(byCmd[9])
    Digit1 := HexToDec(byCmd[8])  <<  4 
    return ( Digit1 | Digit0 )

PUB CalcHubAddress

    Digit0 := HexToDec(byCmd[6])
    Digit1 := HexToDec(byCmd[5]) <<  4
    Digit2 := HexToDec(byCmd[4]) <<  8
    Digit3 := HexToDec(byCmd[3]) << 12
    return ( Digit3 | Digit2 | Digit1 | Digit0 )

PUB HexToDec(Value) :Index
    Index := lookdownz(Value: 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70)

PUB DecToHex(Value) :Char
    Char := lookupz(Value: 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70)

PUB CommandTooLong
  CRLF
  ParseError

PUB ClearCmd
  repeat i from 0 to 20
    byCmd[i]:=63   '= ?
  pc.char(">")
  byPntr:=0

PUB ParseError
  pc.str(string("SYNTAX ERROR "))
  pc.hex(cntEscapes,2)
  pc.str(string(" press ?"))
  CRLF

PUB Escape
  ParseError

PUB Help
  pc.clear
  pc.str(string("    *****     Propeller Read & Write HUB adresses    *****    (IVE 260158)"))
  CRLF
  pc.str(string("    Read  Long/Word/Byte   > RL AAAA,          RW AAAA,      RB AAAA"))
  CRLF
  pc.str(string("    Write Long/Word/Byte   > WL AAAA VVVVVVVV, WW AAAA VVVV, WB AAAA VV"))
  CRLF
  pc.str(string("                                AAAA = HUB address (Hex)"))
  CRLF
  pc.str(string("                                VV.. = Value       (Hex)"))
  CRLF
  pc.str(string("     ?  = clear screen and displays help"))
  CRLF
  pc.str(string("    ESC = abort command"))
  CRLF
       
PUB CRLF
  pc.char(CR)
  pc.char(LF)

PUB ParseCommand

  xRL := false
  xRW := false
  xRB := false
  xWL := false
  xWW := false
  xWB := false
  xParseError:=true

  IF (byCmd[0] == "R")
    IF (byCmd[1] == "L") and (byCmd[2] == " ")
      xRL :=true
      xParseError:=false
    IF (byCmd[1] == "W") and (byCmd[2] == " ")
      xRW :=true
      xParseError:=false
    IF (byCmd[1] == "B") and (byCmd[2] == " ")
      xRB :=true
      xParseError:=false

  IF (byCmd[0] == "W")
    IF (byCmd[1] == "L") and (byCmd[2] == " ") and (byCmd[7] == " ")
      xWL :=true
      xParseError:=false
    IF (byCmd[1] == "W") and (byCmd[2] == " ") and (byCmd[7] == " ")
      xWW :=true
      xParseError:=false
    IF (byCmd[1] == "B") and (byCmd[2] == " ") and (byCmd[7] == " ")
      xWB :=true
      xParseError:=false

  xParseError := not ( xRL or xRW or xRB or xWL or xWW or xWB )

  if not xParseError
    xParseError := not CheckHexValue(byCmd[3])
  if not xParseError
    xParseError := not CheckHexValue(byCmd[4])
  if not xParseError
    xParseError := not CheckHexValue(byCmd[5])
  if not xParseError
    xParseError := not CheckHexValue(byCmd[6])
       
  IF xWL | xWW | xWB
    if not xParseError
      xParseError := not CheckHexValue(byCmd[8])
    if not xParseError
      xParseError := not CheckHexValue(byCmd[9])

    IF xWL | xWW
      if not xParseError
        xParseError := not CheckHexValue(byCmd[10])
      if not xParseError
        xParseError := not CheckHexValue(byCmd[11])

    IF xWL
      if not xParseError
        xParseError := not CheckHexValue(byCmd[12])
      if not xParseError
        xParseError := not CheckHexValue(byCmd[13])
      if not xParseError
        xParseError := not CheckHexValue(byCmd[14])
      if not xParseError
        xParseError := not CheckHexValue(byCmd[15])

PUB CheckHexValue(value)

  IF ((value => 65) AND (value =< 70)) OR ((value => 48) AND (value =< 57))
    return true
  else   
    return false