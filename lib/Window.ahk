class Window extends Gdip.Drawing
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
	
	Update(paramObj=0)
	{
		if (paramObj.x != "")
			this.point.x := paramObj.x
		if (paramObj.y != "")
			this.point.y := paramObj.y

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