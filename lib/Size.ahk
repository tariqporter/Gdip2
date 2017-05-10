class Size
{
	__New(params*)
	{
		c := params.MaxIndex()
		if (c = 2)
		{
			if (IsObject(params[1]))
			{
				this.width := Round(params[1].width * params[2])
				this.height := Round(params[1].height * params[2])
			}
			else
			{
				
				this.width := params[1]
				this.height := params[2]
			}
		}
		else if (c = 3)
		{
			size1 := params[1]
			this.width := size1.width + params[2]
			this.height := size1.height + params[3]
		}
		else
			throw "Incorrect number of parameters for Size.New()"
	}
}