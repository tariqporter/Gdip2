class Shape
{
	static mapping := { "position":"position", "left":"left", "top":"top", "width":"width", "height":"height", "background-color":"backgroundColor", "border-radius":"borderRadius", "border-color":"borderColor", "border-width":"borderWidth", "color":"color", "text-align":"textAlign", "vertical-align":"verticalAlign", "font-size":"fontSize" }
	static defaults := [  ["position","relative"], ["left","0px"], ["top","0px"], ["width","0px"], ["height","0px"], ["background-color","#000"], ["border-radius","0px"], ["border-color","#000"], ["border-width","0px"], ["color","#000"], ["text-align","left"], ["vertical-align","middle"], ["font-size","16px"] ]
	
	;selector
	;selector,css
	;selector,content
	;selector,css,content
	__New(params*)
	{
		this.style := { css: {}, me: {} }
		this.style.me := css
		this._shapes := {}
		this._windowClass := new Gdip.Window()
		this.selector := { id: "", classList: {}, class: "", classCount: 0 }
		this._styleSheetClass := new Gdip.StyleSheet()
		
		properties := {}
		css := {}
		this.content := ""
		
		c := params.MaxIndex()
		;MsgBox, % params.MaxIndex() "`n" this.content "`n" params[2]
		if (c = 2)
		{
			if (IsObject(params[2]))
				css := params[2]
			else
				this.content := params[2]
		}
		else if (c = 3)
		{
			css := params[2]
			this.content := params[3]
		}

		loop % this.defaults.MaxIndex()
		{
			i := this.defaults[A_Index]
			properties.Insert([ i[1], css.HasKey(i[1]) ? css[i[1]] : i[2] ])
		}
		
		selector := params[1]
		if (selector)
		{
			s1 := this._styleSheetClass._parseSelector(selector)
			this.selector := s1
		}
		this.css(properties)
		;MsgBox, % this.content
	}
	

	text[prm*]
	{
		get {
			if (prm.MaxIndex())
			{
				this.text := prm[1]
			}
			return this.content
		}
		set {
			this.content := value
			return this.content
		}
	}
	
	/*
	text(content={})
	{
		if (content != 0)
			this.content := content
		return this.content
	}
	*/
	
	hasClass(class)
	{
		class := Trim(class)
		return this.selector.classList.HasKey(class)
	}
	
	addClass(class)
	{
		class := Trim(class)
		if (!this.hasClass(class))
		{
			this.selector.classList.Insert(class, class)
			this.selector.class .= class " "
			this.selector.classCount++
		}
	}
	
	removeClass(class)
	{
		class := Trim(class)
		if (this.hasClass(class))
		{
			this.selector.classList.Remove(class)
			classes := " "
			for k, v in this.selector.classList
				classes .= v " "
			this.selector.class := classes
			this.selector.classCount--
		}
	}
	
	toggleClass(class)
	{
		class := Trim(class)
		if (this.hasClass(class))
			this.removeClass(class)
		else
			this.addClass(class)
			
		loop % this._css.MaxIndex()
		{
			cssItem1 := this._css[A_Index]
			match1 := this._windowClass._shapeIsMatch(this.selector, cssItem1.selector)
			if (match1)
				this.styleInsert(cssItem1)
		}
	}
	
	styleInsert(style)
	{
		s1 := style.selector
		inserted := false
		loop % this.style.css.MaxIndex()
		{
			s2 := this.style.css[A_Index].selector
			if ((s1.id && !s2.id) || (s1.id = s2.id && s1.classCount >= s2.classCount))
			{
				this.style.css.Insert(A_Index, style)
				inserted := true
				break
			}
		}
		if (!inserted)
			this.style.css.Insert(style)
		
		styles := {}
		loop % this.style.css.MaxIndex()
		{
			i := this.style.css.MaxIndex() - A_Index + 1
			style2 := this.style.css[i].style
			for k, v in style2
			{
				styles[k] :=  v
			}
		}
		
		for k, v in this.style.me
		{
			styles[k] := v
		}
		
		loop % this.defaults.MaxIndex()
		{
			i := this.defaults[A_Index]
			if (!styles.HasKey(i[1]))
			{
				styles[i[1]] := i[2]
			}
		}
		this.css(styles)
	}
	
	_parseLength(length)
	{
		if (length = 0)
			match1 := 0
		else
			pos1 := RegExMatch(length, "i)(\d*\.*\d+)\s*px", match)
		return match1
	}
	
	left[]
	{
		get {
			return this._left
		}
		set {
			pLength := this._parseLength(value)
			if (pLength != "")
				this._left := pLength
			return this._left
		}
	}
	
	top[]
	{
		get {
			return this._top
		}
		set {
			pLength := this._parseLength(value)
			if (pLength != "")
				this._top := pLength
			return this._top
		}
	}
	
	width[]
	{
		get {
			return this._width
		}
		set {
			pLength := this._parseLength(value)
			if (pLength != "")
				this._width := pLength
			return this._width
		}
	}
	
	height[]
	{
		get {
			return this._height
		}
		set {
			pLength := this._parseLength(value)
			if (pLength != "")
				this._height := pLength
			return this._height
		}
	}
	
	borderRadius[]
	{
		get {
			return this._borderRadius
		}
		set {
			pLength := this._parseLength(value)
			if (pLength != "")
				this._borderRadius := pLength
			return this._borderRadius
		}
	}
	
	color[]
	{
		get {
			return this._color
		}
		set {
			this._color := value
			this.textBrush := value
			return this._textBrush
		}
	}
	
	backgroundColor[]
	{
		get {
			return this._backgroundColor
		}
		set {
			this._backgroundColor := value
			this.brush := value
			return this._backgroundColor
		}
	}
	
	borderColor[]
	{
		get {
			return this._borderColor
		}
		set {
			this._borderColor := value
			this.pen := { "borderColor": value, "borderWidth": this.borderWidth "px" }
			return this._borderColor
		}
	}
	
	borderWidth[]
	{
		get {
			return this._borderWidth
		}
		set {
			this.pen := { "borderColor": this.borderColor, "borderWidth": value }
			return this._borderWidth
		}
	}
	
	_parseColor(color)
	{
		pos1 := RegExMatch(color, "i)#([\da-f]+)", match)
		if (pos1)
		{
			m := "0x" match1
			if (m <= 0xffffff)
			{
				m := (0xffffffff << 24) | m
			}
		}
		else if (pos1 := RegExMatch(color, "i)rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)", match))
		{
			m := (255 << 24) | (match1 << 16) | (match2 << 8) | match3
		}
		else if (pos1 := RegExMatch(color, "i)rgba\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d*\.*\d+)\s*\)", match))
		{
			A := match4 * 255
			m := (A << 24) | (match1 << 16) | (match2 << 8) | match3
		}
		return m
	}
	
	textBrush[]
	{
		get {
			return this._textBrush
		}
		set {
			color := value
			pColor := this._parseColor(color)
			if (pColor)
				this._textBrush := new Gdip.Brush(pColor)
			return this._textBrush
		}
	}
	
	brush[]
	{
		get {
			return this._brush
		}
		set {
			color := value
			pColor := this._parseColor(color)
			if (pColor)
				this._brush := new Gdip.Brush(pColor)
			return this._brush
		}
	}
	
	pen[]
	{
		get {
			return this._pen
		}
		set {
			bw := this._parseLength(value.borderWidth)
			if (bw > 0)
			{
				bw := (this.height >= this.width) ? ((bw > this.width / 2) ? this.width / 2 : bw) : ((bw > this.height / 2) ? this.height / 2 : bw)
				color := value.borderColor
				pColor := this._parseColor(color)
				this._pen := new Gdip.Pen(pColor, bw)
			}
			else
			{
				this._pen := { width: 0 }
			}
			return this._pen
		}
	}
	
	shapeInsert(params*)
	{
		shape := new Gdip.Shape(params*)
		this._shapes.Insert(shape)
		loop % this._css.MaxIndex()
		{
			cssItem1 := this._css[A_Index]
			match1 := this._windowClass._shapeIsMatch(shape.selector, cssItem1.selector)
			if (match1)
				shape.styleInsert(cssItem1)
		}
		shape._css := this._css
		return shape
	}
	
	css(params*)
	{
		c := params.MaxIndex()
		if (c = 1)
		{
			paramObj := params[1]
			if (paramObj.MaxIndex())
			{
				loop % paramObj.MaxIndex()
				{
					i := paramObj[A_Index]
					this[this.mapping[i[1]]] := i[2]
				}
			}
			else
			{
				loop % this.defaults.MaxIndex()
				{
					i := this.defaults[A_Index]
					if (paramObj.HasKey(i[1]))
						this[this.mapping[i[1]]] := paramObj[i[1]]
				}
			}
		}
		else if (c = 2)
		{
			this[this.mapping[params[1]]] := params[2]
		}
		else
			throw "Incorrect number of parameters for Shape.css()"
	}
}
