class StyleSheet
{
	__New(params*)
	{
		this.items := {}
		chars1 := ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9","-","_"]
		this.whiteSpace := {" ":1,"\t":1}
		this.chars := {}
		loop % chars1.MaxIndex()
			this.chars.Insert(chars1[A_Index], 1)
			
		c := params.MaxIndex()
		if (!c)
		{
		}
		else if (Mod(c, 2))
		{
			throw "Incorrect number of arguments in StyleSheet.New"
		}
		else
		{
			loop % params.MaxIndex() / 2
			{
				i := A_Index * 2 - 1
				if !(IsObject(style := params[i + 1]))
				{
					throw "Bad style in StyleSheet.New"
				}
				this.items.Insert({ selector: this._parseSelector(params[i]), style: style })
			}
		}
	}
	
	/*
	_getClass(selector)
	{
		classList := selector.classList
		classes := " "
		for k, v in classList
			classes .= v " "
		return classes
	}
	*/
	
	_parseSelector(selector)
	{
		inID := false
		inClass := false
		id1 := id2 := ""
		class1 := "", class2 := " "
		classes := []
		classCount := 0
		loop % StrLen(selector)
		{
			chr := SubStr(selector, A_Index, 1)
			if (inID)
			{
				if (this.chars.HasKey(chr))
					id1 .= chr
				else if (this.whiteSpace.HasKey(chr))
				{
					id2 := id1
					id1 := ""
					inID := false
				}
				else if (chr = ".")
				{
					id2 := id1
					id1 := ""
					inID := false
					inClass := true
				}
				else
					throw "Bad id in StyleSheet._parseSelector"
			}
			else if (inClass)
			{
				if (this.chars.HasKey(chr))
				{
					class1 .= chr
				}
				else if (this.whiteSpace.HasKey(chr))
				{
					classes.Insert(class1, class1)
					classCount++
					;MsgBox, % "here 1: "class1
					class2 .= class1 " "
					class1 := ""
					inClass := false
				}
				else if (chr = ".")
				{
					classes.Insert(class1, class1)
					classCount++
					;MsgBox, % "here 2: "class1
					class2 .= class1 " "
					class1 := ""
					;inClass := true
				}
				else
					throw "Bad class in StyleSheet._parseSelector"
			}
			else if (chr = "#")
				inID := true
			else if (chr = ".")
				inClass := true
		}
		;MsgBox, % class1
		if (class1)
		{
			classes.Insert(class1, class1)
			classCount++
			class2 .= class1 " "
		}
		if (id1)
			id2 := id1
		return { id: id2, classList: classes, class: class2, classCount: classCount }
	}
}