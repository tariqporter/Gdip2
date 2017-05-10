#Persistent
#SingleInstance Force

#Include ..\dist\Gdip2.ahk

gdip1 := new Gdip()
win1 := new gdip.Window(new gdip.Size(1400, 1050))
brush1 := new gdip.Brush(255, 0, 0)
win1.obj.FillEllipse(brush1, new gdip.Point(100, 500), new gdip.Size(200, 300))
brush2 := new gdip.Brush(102, 0, 0, 255)
win1.obj.FillRectangle(brush2, new gdip.Point(250, 80), new gdip.Size(300, 200))
win1.Update()
return

;#####################################################################################

Esc::
ExitApp
return
