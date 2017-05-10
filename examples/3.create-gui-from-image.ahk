#Persistent
#SingleInstance Force

#Include ..\dist\Gdip2.ahk

; Start Gdip
gdip1 := new Gdip()

; Get a bitmap from the image
bitmap1 := gdip1.BitmapFromFile("background.png")

; Check to ensure we actually got a bitmap from the file, in case the file was corrupt or some other error occured
if !bitmap1.Pointer
{
	MsgBox, 48, File loading error!, Could not load 'background.png'
	ExitApp
}

; Create a window with the size of our bitmap
win1 := new gdip1.Window(bitmap1.size)

; Draw our bitmap into our window, at x = 0, y = 0
; The 3rd paramter is a size object we want to draw our image
; A size object can be instantiated with an existing size object as its first paramter, and < 1 as second. The width and height will be multiplied
; by this 2nd value and a new size object returned
win1.obj.DrawImage(bitmap1, new gdip1.Point(0, 0), new gdip.Size(bitmap1.size, 0.5))

; Update the window with its current position
win1.Update()
return

;#####################################################################################

Esc::
ExitApp
return
