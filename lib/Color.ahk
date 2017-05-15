class Color
{
	;ARGB
	;R, G, B
	;A, R, G, B
	__New(params*)
	{
		c := params.MaxIndex()
		if (c = 1)
		{
			this.ARGB := params[1]
		}
		else if (c = 3)
		{
			this.ARGB := (255 << 24) | (params[1] << 16) | (params[2] << 8) | params[3]
		}
		else if (c = 4)
		{
			this.ARGB := (params[1] << 24) | (params[2] << 16) | (params[3] << 8) | params[4]
		}
		else
			throw "Incorrect number of parameters for Color.New()"
		
		this.A := (0xff000000 & this.ARGB) >> 24
		this.R := (0x00ff0000 & this.ARGB) >> 16
		this.G := (0x0000ff00 & this.ARGB) >> 8
		this.B := 0x000000ff & this.ARGB
	}
}