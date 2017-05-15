#Persistent
#SingleInstance Force

#Include ..\dist\Gdip2.ahk

; Get the dimensions of the primary monitor
SysGet, MonitorPrimary, MonitorPrimary
SysGet, wa, MonitorWorkArea, %MonitorPrimary%
waWidth := waRight - waLeft
waHeight := waBottom - waTop

; Start Gdip
gdip1 := new Gdip()

; Create a window with width and height of the work area
size1 := new gdip1.Size(waWidth, waHeight)
win1 := new gdip1.Window(size1)

SetTimer, DrawCircle, 200
return

;#######################################################################

DrawCircle:
Random, backColor, -2147483648, 2147483647
Random, foreColor, -2147483648, 2147483647
Random, hatchStyle, 0, 53
Random, elipseWidth, 1, 200
Random, elipseHeight, 1, 200
Random, elipseXPos, % waLeft, % waWidth - elipseWidth
Random, elipseYPos, % waTop, % waHeight - elipseHeight

; Create a solid brush using 2 Color objects
; Random only allows -2147483648 to 2147483647, but ARGB is 0xFFFFFFFF, so we must add 2147483647 to make sure it is non-negative
brush1 := new gdip1.Brush(new gdip1.Color(backColor + 2147483647), new gdip1.Color(foreColor + 2147483647), hatchStyle)

; We can call any draw/fill function with x, y, w, h, or we can use a point object, size object
win1.obj.FillEllipse(brush1, elipseXPos, elipseYPos, elipseWidth, elipseHeight)
win1.Update()
return

;#######################################################################

Esc::
ExitApp
return