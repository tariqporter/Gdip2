class Point
{
	__New(params*)
	{
		c := params.MaxIndex()
		if (c = 2)
		{
			this.X := params[1]
			this.Y := params[2]
		}
		else if (c = 3)
		{
			point1 := params[1]
			this.X := point1.X + params[2]
			this.Y := point1.Y + params[3]
		}
		else
			throw "Incorrect number of parameters for Point.New()"
	}
}