#Persistent
#SingleInstance Force

#Include ..\dist\Gdip2.ahk

; Start Gdip
gdip1 := new Gdip()

; Create a window w = 600, h = 400 using a Size Object
win1 := new Gdip.Window(new Gdip.Size(600, 400))

; Create a solid brush using R, G, B
brush1 := new Gdip.Brush(255, 0, 0)

; We can call any draw/fill function with x, y, w, h, or we can use a point object, size object
win1.FillEllipse(brush1, 100, 50, 200, 300)

; Create solid brush using A, R, G, B
brush2 := new Gdip.Brush(102, 0, 0, 255)

; We can call any draw/fill function with x, y, w, h, or we can use a point object, size object
win1.FillRectangle(brush2, new Gdip.Point(250, 80), new Gdip.Size(300, 200))

; Update the window with its current position
win1.Update()
return

;#####################################################################################

Esc::
ExitApp
return
