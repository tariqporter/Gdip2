#Persistent
#SingleInstance Force

#Include ..\dist\Gdip2.ahk

; Start Gdip
gdip1 := new Gdip()

; Get a bitmap from the image
bitmap1 := Gdip.BitmapFromFile("background.png")

; Check to ensure we actually got a bitmap from the file, in case the file was corrupt or some other error occured
if !bitmap1.Pointer
{
	MsgBox, 48, File loading error!, Could not load 'background.png'
	ExitApp
}

; A size object can be instantiated with an existing size object as its first paramter, and < 1 as second. The width and height will be multiplied
; by this 2nd value and a new size object returned
size1 := new Gdip.Size(bitmap1.size, 0.5)

; Create a window with the size of our bitmap
win1 := new Gdip.Window(size1)
;MsgBox, % win1.width

; Draw our bitmap into our window, at x = 0, y = 0
; The 3rd paramter is a size object we want to draw our image
win1.DrawImage(bitmap1, new Gdip.Point(0, 0), size1)

; Update the window with its current position
win1.Update()
return

;#####################################################################################

Esc::
ExitApp
return
