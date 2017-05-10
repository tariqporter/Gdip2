class Brush
{
	;ARGB
	;R, G, B
	;A, R, G, B
	__New(params*)
	{
		c := params.MaxIndex()
		if (c = 1)
		{
			ARGB := params[1]
		}
		else if (c = 3)
		{
			ARGB := (255 << 24) | (params[1] << 16) | (params[2] << 8) | params[3]
		}
		else if (c = 4)
		{
			ARGB := (params[1] << 24) | (params[2] << 16) | (params[3] << 8) | params[4]
		}
		else
			throw "Incorrect number of parameters for Brush.New()"
		this.Pointer := this.CreateSolid(ARGB)
	}
	
	__Delete()
	{
		this.Dispose()
	}
	
	Dispose()
	{
		return DllCall("gdiplus\GdipDeleteBrush", "uptr", this.Pointer)
	}
	
	CreateSolid(ARGB)
	{
		DllCall("gdiplus\GdipCreateSolidFill", "uint", ARGB, "uptr*", pBrush)
		return pBrush
	}
}