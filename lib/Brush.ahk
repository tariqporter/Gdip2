class Brush
{
	;ARGB
	;Color
	;R, G, B
	;Color, Color, hatchStyle
	;A, R, G, B
	__New(params*)
	{
		c := params.MaxIndex()
		if (c = 1)
		{
			if (params[1].__Class = "Gdip.Color")
			{
				this.Color := params[1]
				this.Pointer := this.CreateSolid(this.Color.ARGB)
			}
			else
			{
				this.Color := new Gdip.Color(params[1])
				this.Pointer := this.CreateSolid(this.Color.ARGB)
			}
		}
		else if (c = 3)
		{
			if (params[1].__Class = "Gdip.Color")
			{
				this.Color := { "Front": params[1], "Back": params[2] }
				this.HatchStyle := params[3]
				this.Pointer := this.CreateHatch(this.Color.Front.ARGB, this.Color.Back.ARGB, this.HatchStyle)
			}
			else
			{
				this.Color := new Gdip.Color((255 << 24) | (params[1] << 16) | (params[2] << 8) | params[3])
				this.Pointer := this.CreateSolid(this.Color.ARGB)
			}
		}
		else if (c = 4)
		{
			this.Color := new Gdip.Color((params[1] << 24) | (params[2] << 16) | (params[3] << 8) | params[4])
			this.Pointer := this.CreateSolid(this.Color.ARGB)
		}
		else
			throw "Incorrect number of parameters for Brush.New()"
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
	
	CreateHatch(ARGBFront, ARGBBack, hatchStyle=0)
	{
		DllCall("gdiplus\GdipCreateHatchBrush", "int", hatchStyle, "uint", ARGBfront, "uint", ARGBback, "uptr*", pBrush)
		return pBrush
	}
}