class ShapeCollection
{
	__New(params*)
	{
		c := params.MaxIndex()
		if (!c)
		{
		}
		else if (c = 1)
		{
			this.items.Insert(params[1])
		}
		else
			throw "Incorrect number of parameters for ShapeCollection.New()"
			
		this.items := {}
		this._windowClass := new Gdip.Window()
		/*
		this.mousemove := { "function": 0, "parameters": 0 }
		this.mouseenter := { "function": 0, "parameters": 0 }
		this.mouseleave := { "function": 0, "parameters": 0 }
		this.click := { "function": 0, "parameters": 0 }
		this.mousedown := { "function": 0, "parameters": 0 }
		this.mouseup := { "function": 0, "parameters": 0 }
		*/
	}
	
	text[prm*]
	{
		get {
			content := ""
			loop % this.items.MaxIndex()
			{
				if (prm.MaxIndex())
				{
					this.items[A_Index].text := prm[1]
				}
				else
					content .= this.items[A_Index].text " "
			}
			return (prm.MaxIndex()) ? this : content
		}
		set {
			loop % this.items.MaxIndex()
			{
				this.items[A_Index].content := value
			}
			return this.content
		}
	}
	
	; selectorObj
	styleInsert(style)
	{
		loop % this.items.MaxIndex()
		{
			this.items[A_Index].styleInsert(style)
		}
		return this
	}
	
	addClass(class)
	{
		loop % this.items.MaxIndex()
		{
			shape := this.items[A_Index]
			shape.addClass(class)
			loop % this._css.MaxIndex()
			{
				cssItem1 := this._css[A_Index]
				match1 := this._windowClass._shapeIsMatch(shape.selector, cssItem1.selector)
				if (match1)
					shape.styleInsert(cssItem1)
			}
		}
		return this
	}
	
	removeClass(class)
	{
		loop % this.items.MaxIndex()
		{
			shape := this.items[A_Index]
			shape.removeClass(class)
			loop % this._css.MaxIndex()
			{
				cssItem1 := this._css[A_Index]
				match1 := this._windowClass._shapeIsMatch(shape.selector, cssItem1.selector)
				if (match1)
					shape.styleInsert(cssItem1)
			}
		}
		return this
	}
	
	toggleClass(class)
	{
		loop % this.items.MaxIndex()
		{
			shape := this.items[A_Index]
			shape.toggleClass(class)
		}
		return this
	}
	
	css(params*)
	{
		;MsgBox, % this.items.MaxIndex()
		loop % this.items.MaxIndex()
		{
			this.items[A_Index].css(params*)
		}
		return this
	}
}