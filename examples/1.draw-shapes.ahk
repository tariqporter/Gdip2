#Persistent
#SingleInstance Force

#Include ..\dist\Gdip2.ahk

; Start Gdip
gdip1 := new Gdip()

; Create a window w = 1400, h = 1050 using a Size Object
win1 := new gdip.Window(new gdip.Size(1400, 1050))

; Create a solid brush using R, G, B
brush1 := new gdip.Brush(255, 0, 0)

; We can call any draw/fill function with x, y, w, h, or we can use a point object, size object
win1.obj.FillEllipse(brush1, 100, 500, 200, 300)

; Create solid brush using A, R, G, B
brush2 := new gdip.Brush(102, 0, 0, 255)

; We can call any draw/fill function with x, y, w, h, or we can use a point object, size object
win1.obj.FillRectangle(brush2, new gdip.Point(250, 80), new gdip.Size(300, 200))

; Update the window with its current position
win1.Update()
return

;#####################################################################################

Esc::
ExitApp
return
