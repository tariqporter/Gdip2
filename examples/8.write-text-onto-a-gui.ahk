#Persistent
#SingleInstance Force

#Include ..\dist\Gdip2.ahk

; Start Gdip
gdip1 := new Gdip()

; Create a window w = 300, h = 200 using a Size Object
size1 := new gdip1.Size(300, 200)
win1 := new gdip1.Window(size1)

; Create a solid brush using A, R, G, B
brush1 := new gdip1.Brush(170, 0, 0, 0)

; We can call any draw/fill function with x, y, w, h, or we can use a point object, size object
win1.FillRoundedRectangle(brush1, new gdip1.Point(0, 0), size1, 20)

options1 := {}
options1.brush := new gdip1.Brush(187, 255, 255, 255)
options1.style := ["underline", "italic"]
options1.horizontalAlign := "center"
options1.width := win1.width
options1.height := win1.height
options1.size := 20
win1.WriteText("Tutorial 8`n`nThank you for trying this example", options1)

; Update the window with its current position
win1.Update({ x: (A_ScreenWidth-size1.width)//2, y: (A_ScreenHeight-size1.height)//2 })

; By placing this OnMessage here. The function WM_LBUTTONDOWN will be called every time the user left clicks on the gui
OnMessage(0x201, "WM_LBUTTONDOWN")
return

;#######################################################################

; This function is called every time the user clicks on the gui
; The PostMessage will act on the last found window (this being the gui that launched the subroutine, hence the last parameter not being needed)
WM_LBUTTONDOWN()
{
   PostMessage, 0xA1, 2
}

;#####################################################################################

Esc::
ExitApp
return
