#Persistent
#SingleInstance Force

#Include ..\dist\Gdip2.ahk

; Start Gdip
gdip1 := new Gdip()

; Create a window w = 600, h = 400 using a Size Object
bitmap1 := new Gdip.Bitmap(new gdip1.Size(400, 400))

; Create a solid brush using R, G, B
brush1 := new Gdip.Brush(new Gdip.Color(85, 50, 35), new Gdip.Color(190, 160, 140), 31)

; We can call any draw/fill function with x, y, w, h, or we can use a point object, size object
bitmap1.FillRectangle(brush1, (400-200)//2, (400-250)//2, 200, 250)

brush1 := new Gdip.Brush(new Gdip.Color(0, 0, 0), new Gdip.Color(80, 50, 55), 31)

; We can call any draw/fill function with x, y, w, h, or we can use a point object, size object
bitmap1.FillPie(brush1, (400-80)//2, (400-80)//2, 80, 80, 250, 40)

; Create a white brush and black brush
brushWhite := new Gdip.Brush(0xffffffff), brushBlack := new Gdip.Brush(0xff000000)

; Loop to draw 2 ellipses filling them with white then black in the centre of each
loop, 2
{
	x := (A_Index = 1) ? 120 : 220, y := 100
	bitmap1.FillEllipse(brushWhite, x, y, 60, 60)
	x += 15, y += 15
	bitmap1.FillEllipse(brushBlack, x, y, 30, 30)
}

; Create a hatched brush with background and foreground colours specified (HatchStyle30Percent = 10)
; Again draw another ellipse into the graphics with the specified brush
bitmap1.FillPie(new Gdip.Brush(new Gdip.Color(0xfff22231), new Gdip.Color(0xffa10f19), 10), 150, 200, 100, 80, 0, 180)

pen1 := new Gdip.Pen(0xbb000000, 3)

; Create some coordinates for the lines in format x1,y1,x2,y2 then loop and draw all the lines
lines = 180,200,130,220|180,190,130,195|220,200,270,220|220,190,270,195
Loop, Parse, lines, |
{
	StringSplit, pos, A_LoopField, `,
	bitmap1.DrawLine(pen1, pos1, pos2, pos3, pos4)
}

; Update the window with its current position
bitmap1.SaveToFile("file.png")
return

;#####################################################################################

Esc::
ExitApp
return
