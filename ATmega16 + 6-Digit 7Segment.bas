'======================================================================='

' Title: 6-Digit 7Seg LED Clock
' Last Updated :  04.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : ATmega16 + 6-Digit 7Segment

'======================================================================='

$regfile = "m16def.dat"
$crystal = 1000000

Config Pina.0 = Input
Config Pina.1 = Input
Config Pina.2 = Output
Config Portb = Output
Config Portd = Output

Config Clock = Soft
Enable Interrupts

Dim A As Bit
Dim D As Bit
Dim M As Byte
Dim T As Byte
Set Porta.0
Set Porta.1
Set Porta.2
Declare Sub Main
Declare Sub Dat
Declare Sub Button
Time$ = "12:00:00"

'-----------------------------------------------------------

Do

If Pina.0 = 0 Then
Toggle A
Call Button
End If

Select Case A

 Case Is = 0
   If Pina.1 = 0 Then
   Incr _min
   If _min > 59 Then _min = 0
   Call Button
   End If
   If Pina.2 = 0 Then
   Decr _min
   If _min = 255 Then _min = 59
   Call Button
   End If

 Case Is = 1

   If Pina.1 = 0 Then
   Incr _hour
   If _hour > 23 Then _hour = 0
   Call Button
   End If
   If Pina.2 = 0 Then
   Decr _hour
   If _hour = 255 Then _hour = 23
   Call Button
   End If

 End Select

Call Main

Loop

End

'-----------------------------------------------------------

Main:

Portb = &B11011111
D = 0
T = _hour / 10
Call Dat

Portb = &B11101111
D = 1 :
T = _hour Mod 10
Call Dat

Portb = &B11110111
D = 0
T = _min / 10
Call Dat

Portb = &B11111011
D = 1
T = _min Mod 10
Call Dat

Portb = &B11111101
D = 0
T = _sec / 10
Call Dat

Portb = &B11111110
D = 0
T = _sec Mod 10
Call Dat

''''''''''''''''''''''''''''''

Sub Dat

Portd = Lookup(t , Segment)
If D = 1 Then
Portd.7 = 1
End If
Waitms 4

End Sub

''''''''''''''''''''''''''''''

Button:

For M = 1 To 5
Call Main
Next

'-----------------------------------------------------------
Segment:

Data &H3F , &H06 , &H5B , &H4F , &H66 , &H6D , &H7D , &H07 , &H7F , &H6F
'-----------------------------------------------------------