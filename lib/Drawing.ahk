class Drawing
{
	__New(params*)
	{
		c := params.MaxIndex()
		if (!c)
		{
		}
		else
			throw "Incorrect number of parameters for Bitmap.New()"
	}
	
	FillEllipse(params*)
	{
		return this.obj.FillEllipse(params*)
	}
	
	FillRectangle(params*)
	{
		return this.obj.FillRectangle(params*)
	}
	
	DrawEllipse(params*)
	{
		return this.obj.DrawEllipse(params*)
	}
	
	DrawRectangle(params*)
	{
		return this.obj.DrawRectangle(params*)
	}
	
	DrawImage(params*)
	{
		return this.obj.DrawImage(params*)
	}
	
	DrawLine(params*)
	{
		return this.obj.DrawLine(params*)
	}
	
	FillRoundedRectangle(params*)
	{
		return this.obj.FillRoundedRectangle(params*)
	}
	
	FillPie(params*)
	{
		return this.obj.FillPie(params*)
	}
	
	WriteText(params*)
	{
		return this.obj.WriteText(params*)
	}
}