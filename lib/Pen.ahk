class Pen
{
	;ARGB, w
	;R, G, B, w
	;A, R, G, B, w
	__New(params*)
	{
		c := params.MaxIndex()
		if (c = 2)
		{
			ARGB := params[1]
			width := params[2]
			;MsgBox, % ARGB "`n" width
		}
		else if (c = 4)
		{
			;MsgBox, % params[1] "`n" params[2] "`n" params[3] "`n" params[4]
			ARGB := (255 << 24) | (params[1] << 16) | (params[2] << 8) | params[3]
			width := params[4]
		}
		else if (c = 5)
		{
			ARGB := (params[1] << 24) | (params[2] << 16) | (params[3] << 8) | params[4]
			width := params[5]
		}
		else
			throw "Incorrect number of parameters for Pen.New()"
		this.Pointer := this.CreatePen(ARGB, width)
		this.width := width
	}
	
	__Delete()
	{
		this.Dispose()
	}
	
	Dispose()
	{
		return DllCall("gdiplus\GdipDeletePen", "uptr", this.Pointer)
	}
	
	CreatePen(ARGB, w)
	{
		;MsgBox, % ARGB "`n" w
		
		;A := (0xff000000 & ARGB) >> 24
		;R := (0x00ff0000 & ARGB) >> 16
		;G := (0x0000ff00 & ARGB) >> 8
		;B := 0x000000ff & ARGB
		
		;MsgBox, % A "`n" R "`n" G "`n" B "`n" w

		DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "float", w, "int", 2, "uptr*", pPen)
		return pPen
	}
}