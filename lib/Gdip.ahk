class Gdip
{
	__New()
	{
		if !DllCall("GetModuleHandle", "str", "gdiplus")
			DllCall("LoadLibrary", "str", "gdiplus")
		VarSetCapacity(si, (A_PtrSize = 8) ? 24 : 16, 0), si := Chr(1)
		DllCall("gdiplus\GdiplusStartup", "uptr*", pToken, "uptr", &si, "uint", 0)
		this.pToken := pToken

		this._New := Gdip.__New
		Gdip.__New := Gdip._DummyNew
	}
	
	_DummyNew()
	{
		return false
	}
	
	__Delete()
	{
		this.Dispose()
	}
	
	Dispose()
	{
		DllCall("gdiplus\GdiplusShutdown", "uptr", this.pToken)
		if (hModule := DllCall("GetModuleHandle", "str", "gdiplus"))
			DllCall("FreeLibrary", "uptr", hModule)
			
		Gdip.__New := this._New
	}
	
	BitmapFromScreen(params*)
	{
		bitmap1 := new Gdip.Bitmap()
		bitmap1.Pointer := bitmap1.BitmapFromScreen(params*)
		return bitmap1
	}
	
	BitmapFromZip(zipObj, file)
	{
		bitmap1 := new Gdip.Bitmap()
		bitmap1.Pointer := bitmap1.BitmapFromZip(zipObj, file)
		return bitmap1
	}
	
	BitmapFromFile(file)
	{
		bitmap1 := new Gdip.Bitmap()
		bitmap1.Pointer := bitmap1.BitmapFromFile(file)
		return bitmap1
	}
	
	#Include Brush.ahk
	
	#Include Pen.ahk
	
	#Include Window.ahk
	
	#Include Point.ahk
	
	#Include Size.ahk
	
	#Include Zip.ahk
	
	#Include Bitmap.ahk
	
	#Include Object.ahk
}