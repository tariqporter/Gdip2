class Bitmap extends Gdip.Drawing
{
	;size
	;width, height
	;width, height, format
	__New(params*)
	{
		c := params.MaxIndex()
		this._pointer := 0
		if (!c)
		{
			
		}
		else if (c = 1)
		{
			this._pointer := this.CreateBitmap(params[1].width, params[1].height)
		}
		else if (c = 2)
		{
			this._pointer := this.CreateBitmap(params[1], params[2])
		}
		else if (c = 3)
		{
			this._pointer := this.CreateBitmap(params[1], params[2], params[3])
		}
		else
			throw "Incorrect number of parameters for Bitmap.New()"

		if (this._pointer != 0)
		{
			width := this.GetImageWidth(this.Pointer)
			height := this.GetImageHeight(this.Pointer)
			this.size := new Gdip.Size(width, height)
			this.obj := new Gdip.Object(this)
		}
	}

	Pointer[]
	{
		get {
			return this._pointer
		}
		set {
			this._pointer := value
			width := this.GetImageWidth(this._pointer)
			height := this.GetImageHeight(this._pointer)
			this.size := new Gdip.Size(width, height)
			this.obj := new Gdip.Object(this)
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

	__Delete()
	{
		this.Dispose()
	}
	
	Dispose()
	{
		this.DisposeImage(this._pointer)
		this._pointer := 0
	}
	
	DisposeImage(pBitmap)
	{
		return DllCall("gdiplus\GdipDisposeImage", "uptr", pBitmap)
	}
	
	DeleteGraphics(pGraphics)
	{
	   return DllCall("gdiplus\GdipDeleteGraphics", "uptr", pGraphics)
	}
	
	BitmapFromFile(file)
	{
		DllCall("gdiplus\GdipCreateBitmapFromFile", "uptr", &file, "uptr*", pBitmap)
		return pBitmap
	}
	
	BitmapFromZip(zipObj, file)
	{
		pBitmap := 0
		if (file + 0 > 0)
		{
			pBitmap := this.BitmapFromStream(zipObj.Handle, zipObj.Files[file].Offset, zipObj.Files[file].CompressedSize)
		}
		else
		{
			for k, v in zipObj.Files
			{
				if (v.FileName = file)
				{
					pBitmap := this.BitmapFromStream(zipObj.Handle, v.Offset, v.CompressedSize)
					break
				}
			}
		}
		return pBitmap
	}
	
	BitmapFromStream(file, start, size)
	{
		file.Position := start
		file.RawRead(memoryFile, size)
		hData := DllCall("GlobalAlloc", "uint", 2, "ptr", size, "ptr")
		pData := DllCall("GlobalLock", "ptr", hData, "ptr")
		DllCall("RtlMoveMemory", "ptr", pData, "ptr", &memoryFile, "ptr", size)
		unlock := DllCall("GlobalUnlock", "ptr", hData)
		stream := DllCall("ole32\CreateStreamOnHGlobal", "ptr", hData, "int", 1, "uptr*", pStream)
		DllCall("gdiplus\GdipCreateBitmapFromStream", "ptr", pStream, "uptr*", pBitmap)
		ObjRelease(pStream)
		return pBitmap
	}
	
	;screenNumber (0 default)
	;screenNumber, raster
	;{ hwnd: hwnd }
	;{ hwnd: hwnd }, raster
	;x, y, w, h
	;x, y, w, h, raster
	BitmapFromScreen(params*)
	{
		c := params.MaxIndex()
		obj := new Gdip.Object()
		
		if (c = 1 || c = 2)
		{
			if (IsObject(params[1]))
			{
				hwnd := params[1].hwnd
				if !WinExist( "ahk_id " hwnd)
					return -2
				x := 0, y := 0
				WinGetPos,,, w, h, ahk_id %hwnd%
				hhdc := obj.GetDCEx(hwnd, 3)
			}
			else
			{
				if (screen = 0)
				{
					Sysget, x, 76
					Sysget, y, 77	
					Sysget, w, 78
					Sysget, h, 79
				}
				else
				{
					Sysget, M, Monitor, % params[1]
					x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
				}
			}
			raster := params[2] ? params[2] : ""
		}
		else if (c = 4 || c = 5)
		{
			x := params[1], y := params[2], w := params[3], h := params[4]
			raster := params[5] ? params[5] : ""
		}
		else
			throw "Incorrect number of parameters for Bitmap.BitmapFromScreen()"

		chdc := obj.CreateCompatibleDC()
		hbm := obj.CreateDIBSection(w, h, chdc)
		obm := obj.SelectObject(chdc, hbm)
		hhdc := hhdc ? hhdc : obj.GetDC()
		obj.BitBlt(chdc, 0, 0, w, h, hhdc, x, y, raster)
		obj.ReleaseDC(hhdc)
		
		pBitmap := this.CreateBitmapFromHBITMAP(hbm)
		obj.SelectObject(chdc, obm)
		obj.DeleteObject(hbm)
		obj.DeleteDC(hhdc)
		obj.DeleteDC(chdc)
		return pBitmap
	}

	CreateBitmap(width, height, format=0x26200A)
	{
		DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", width, "int", height, "int", 0, "int", format, "uptr", 0, "uptr*", pBitmap)
		return pBitmap
	}
	
	CreateBitmapFromHBITMAP(hBitmap, palette=0)
	{
		DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "uptr", hBitmap, "uptr", palette, "uptr*", pBitmap)
		return pBitmap
	}
	
	CloneBitmapArea(point, size, format=0x26200A)
	{
		bitmap1 := new Gdip.Bitmap()
		bitmap1.Pointer := this._CloneBitmapArea(this.Pointer, point.X, point.Y, size.Width, size.Height, format)
		return bitmap1
	}

	_CloneBitmapArea(pBitmap, x, y, w, h, format=0x26200A)
	{
		DllCall("gdiplus\GdipCloneBitmapArea", "float", x, "float", y, "float", w, "float", h, "int", format, "uptr", pBitmap, "uptr*", pBitmapDest)
		return pBitmapDest
	}
	
	GraphicsFromImage(pBitmap)
	{
		DllCall("gdiplus\GdipGetImageGraphicsContext", "uptr", pBitmap, "uptr*", pGraphics)
		return pGraphics
	}
	
	SaveToFile(output, quality=75)
	{
		return this._SaveBitmapToFile(this.Pointer, output, quality)
	}
	
	_SaveBitmapToFile(pBitmap, output, quality=75)
	{
		SplitPath, output,,, extension
		if extension not in BMP,DIB,RLE,JPG,JPEG,JPE,JFIF,GIF,TIF,TIFF,PNG
			return -1
		extension := "." extension
		
		DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
		VarSetCapacity(ci, nSize)
		DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, "uptr", &ci)
		if !(nCount && nSize)
			return -2
			
		Loop, % nCount
		{
			idx := 104*(A_Index-1)
			sString := StrGet(NumGet(ci, idx+56), "UTF-16")
			if !InStr(sString, "*" extension)
				continue
			pCodec := &ci+idx
			break
		}
		
		if !pCodec
			return -3
			
		if (quality != 75)
		{
			if Extension in .JPG,.JPEG,.JPE,.JFIF
			{
				quality := (quality < 0) ? 0 : (quality > 100) ? 100 : quality
				DllCall("gdiplus\GdipGetEncoderParameterListSize", "uptr", pBitmap, "uptr", pCodec, "uint*", nSize)
				VarSetCapacity(EncoderParameters, nSize, 0)
				DllCall("gdiplus\GdipGetEncoderParameterList", "uptr", pBitmap, "uptr", pCodec, "uint", nSize, "uptr", &EncoderParameters)
				Loop, % NumGet(EncoderParameters, "uint")
				{
					pad := (A_PtrSize = 8) ? 4 : 0
					offset := 32 * (A_Index-1) + 4 + pad
					if (NumGet(EncoderParameters, offset+16, "uint") = 1) && (NumGet(EncoderParameters, offset+20, "uint") = 6)
					{
						encoderParams := offset+&EncoderParameters - pad - 4
						NumPut(quality, NumGet(NumPut(4, NumPut(1, encoderParams+0)+20, "uint")), "uint")
						break
					}
				}      
			}
		}
		E := DllCall("gdiplus\GdipSaveImageToFile", "uptr", pBitmap, "uptr", &output, "uptr", pCodec, "uint", encoderParams ? encoderParams : 0)
		return E ? -5 : 0
	}
	
	;Scale
	;Width, Height
	
	;Scale, ReturnNew
	;Width,Height,ReturnNew
	Resize(params*)
	{
		c := params.MaxIndex()
		if (c = 1)
		{
			size := new Gdip.Size(this.size, params[1])
			dispose := true
		}
		else if (c = 2)
		{
			if (params[2] = 0)
			{
				size := new Gdip.Size(this.size, params[1])
				dispose := false
			}
			else
			{
				size := new Gdip.Size(params[1], params[2])
				dispose := true
			}
		}
		else if (c = 3)
		{
			size := new Gdip.Size(params[1], params[2])
			dispose := params[3]
		}
		else
			throw "Incorrect number of parameters for Bitmap.Resize()"
		

		obj := new Gdip.Object()
		pBitmap := this.CreateBitmap(size.width, size.height)
		pGraphics := this.GraphicsFromImage(pBitmap)
		E := obj.DrawImage(pGraphics, this, new Gdip.Point(0, 0), size)
		
		if (dispose)
		{
			this.DisposeImage(this._pointer)
			this.DeleteGraphics(pGraphics)
			this._pointer := pBitmap
			this.size := size
			return this
		}
		else
		{
			bitmap := new Gdip.Bitmap()
			bitmap.Pointer := pBitmap
			bitmap.size := size
			this.DeleteGraphics(pGraphics)
			return bitmap
		}
	}
	
	GetImageWidth(pBitmap)
	{
		DllCall("gdiplus\GdipGetImageWidth", "uptr", pBitmap, "uint*", width)
		return width
	}
	
	GetImageHeight(pBitmap)
	{
		DllCall("gdiplus\GdipGetImageHeight", "uptr", pBitmap, "uint*", height)
		return height
	}
}