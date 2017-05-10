class Window
{
	__New(params*)
	{
		;size
		;point, size
		c := params.MaxIndex()
		if (!c)
		{
		}
		else if (c = 1)
		{
			point := new Gdip.Point(0, 0)
			size := params[1]
		}
		else if (c = 2)
		{
			point := params[1]
			size := params[2]
		}
		else
			throw "Incorrect number of parameters for Window.New()"

		this.hwnd := DllCall("CreateWindowEx", "uint", 0x80088, "str", "#32770", "ptr", 0, "uint", 0x940A0000
		,"int", point.X, "int", point.Y, "int", size.Width, "int", size.Height, "uptr", 0, "uptr", 0, "uptr", 0, "uptr", 0)
			
		this.point := new Gdip.Point(point.x, point.y)
		this.size := new Gdip.Size(size.width, size.height)
		this.alpha := 255
		this.obj := new Gdip.Object(this.size)
		this.mainLoopObj := { "function": 0, "interval": 0 }
			
		this._shapes := {}
		this._css := {}
		this._styleSheetClass := new Gdip.StyleSheet()
	}
	
	x[]
	{
		get {
			return this.point.x
		}
		set {
			this.point.x := value
		}
	}
	
	y[]
	{
		get {
			return this.point.y
		}
		set {
			this.point.y := value
		}
	}
	
	width[]
	{
		get {
			return this.size.width
		}
	}
	
	height[]
	{
		get {
			return this.size.height
		}
	}
	
	_shapeIsMatch(selector, ms)
	{
		match := true
		if (ms.id && !selector.id) || (ms.id && selector.id && ms.id != selector.id)
		{
			;E := 1
			match := false
		}
		else if (!ms.id || selector.id = ms.id)
		{
			;E := 3
			for k, v in ms.classList
			{
				if (!(selector.classList.HasKey(k)))
				{
					match := false
					break
				}
			}
		}
		else
		{
			;E := 4
			throw "Bad +selector for Window._shapeIsMatch()"
		}
		return match
	}
	
	_parseSelector(selector)
	{
		return this._styleSheetClass._parseSelector(selector)
	}
	
	_matchInnerShapes(shape, ms, matchItems)
	{
		loop % shape._shapes.MaxIndex()
		{
			shape1 := shape._shapes[A_Index]
			match := this._shapeIsMatch(shape1.selector, ms)
			if (match)
			{
				matchItems.Insert(shape1)
			}
			this._matchInnerShapes(shape1, ms, matchItems)
		}
		
	}
	
	shapeMatch(selector)
	{
		;io := IsObject(selector)
		if (IsObject(selector))
		{
			matchSelector := {}
			matchSelector.Insert(selector)
		}
		else
		{
			selector := Trim(RegExReplace(selector, "i)\s+", " "))
			arr := StrSplit(selector, " ")
			matchSelector := []
			loop % arr.MaxIndex()
			{
				ms1 := this._parseSelector(arr[A_Index])
				matchSelector.Insert(ms1)
			}
		}
		
		i := 1
		matchItems := {}
		ms1 := matchSelector[i]
		loop % this._shapes.MaxIndex()
		{
			shape1 := this._shapes[A_Index]
			match := this._shapeIsMatch(shape1.selector, ms1)
			if (match)
				matchItems.Insert(shape1)
			this._matchInnerShapes(shape1, ms1, matchItems)
		}
		
		loop % matchSelector.MaxIndex() - 1
		{
			matchItems2 := {}
			ms1 := matchSelector[++i]
			loop % matchItems.MaxIndex()
			{
				shape2 := matchItems[A_Index]
				this._matchInnerShapes(shape2, ms1, matchItems2)
			}
			matchItems := matchItems2
		}

		sc1 := new Gdip.ShapeCollection()
		sc1.items := matchItems
		sc1._css := this._css
		return sc1
	}
	
	shapeInsert(params*)
	{
		shape := new Gdip.Shape(params*)
		this._shapes.Insert(shape)
		loop % this._css.MaxIndex()
		{
			cssItem1 := this._css[A_Index]
			match1 := this._shapeIsMatch(shape.selector, cssItem1.selector)
			if (match1)
				shape.styleInsert(cssItem1)
		}
		shape._css := this._css
		return shape
	}
	
	styleSheetInsert(css)
	{
		loop % css.items.MaxIndex()
		{
			cssItem1 := css.items[A_Index]
			this._css.Insert(cssItem1)
			shapes := this.shapeMatch(cssItem1)
			shapes.styleInsert(cssItem1)
		}
	}
	
	MainLoop(function, interval, paramObj=0)
	{
		function := Func(function)
		this.mainLoopObj := { "function": function, "interval": interval, "parameters": paramObj }
		fn := this._Update.Bind(this, paramObj)
		SetTimer, % fn, % interval
	}
	
	_Update(paramObj=0)
	{
		this.mainLoopObj.function.(this, this.mainLoopObj.parameters)
		this.Update(paramObj)
	}
	
	_drawInnerShapes(shape)
	{
		loop % shape._shapes.MaxIndex()
		{
			shape1 := shape._shapes[A_Index]
			this.obj.DrawShape(shape1)
			if (shape1._shapes.MaxIndex())
				this._drawInnerShapes(shape1)
		}
	}
	
	Update(paramObj=0)
	{
		if (paramObj.x != "")
			this.point.x := paramObj.x
		if (paramObj.y != "")
			this.point.y := paramObj.y
		
		this.obj.Clear()

		loop % this._shapes.MaxIndex()
		{
			shape1 := this._shapes[A_Index]
			this.obj.DrawShape(shape1)
			this._drawInnerShapes(shape1)
		}
		return this.UpdateLayeredWindow(this.hwnd, this.obj.hdc, this.x, this.y, this.width, this.height, this.alpha)
	}
	
	UpdateLayeredWindow(hwnd, hdc, x="", y="", w="", h="", alpha=255)
	{
		if ((x != "") && (y != ""))
			VarSetCapacity(pt, 8), NumPut(x, pt, 0, "uint"), NumPut(y, pt, 4, "uint")

		if ((w = "") || (h = ""))
			WinGetPos,,, w, h, ahk_id %hwnd%
			
		return DllCall("UpdateLayeredWindow", "uptr", hwnd, "uptr", 0, "uptr", ((x = "") && (y = "")) ? 0 : &pt, "int64*", w|h<<32, "uptr", hdc, "int64*", 0, "uint", 0, "uint*", alpha<<16|1<<24, "uint", 2)
	}
}