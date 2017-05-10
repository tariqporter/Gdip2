class Zip
{
	;file
	__New(params*)
	{
		c := params.MaxIndex()
		if (c = 1)
		{
			file := FileOpen(params[1], "r")
			this.Handle := file
			this.Files := this.ListFiles(file)
		}
		else
			throw "Incorrect number of parameters for Zip.New()"
	}
	
	Dispose()
	{
		this.Handle.Close()
		this.Handle := ""
		this.Files := ""
	}
	
	__Delete()
	{
		this.Dispose()
	}
	
	GetIndex(file)
	{
		index := -1
		for k, v in this.Files
		{
			if (v.FileName = file)
			{
				index := k
				break
			}
		}
		return index
	}
	
	ListFiles(file)
	{
		fileSize := file.Length
		
		array := []
		;array := {}
		file.Position := fileSize - 46
		
		i := 0
		while(i < 1000 || file.Position <= 5)
		{
			signature := file.ReadUInt()
			if (signature = 0x02014b50)
			{
				i := 0
				file.Seek(16, 1)
				compressedSize := file.ReadInt()
				uncompressedSize := file.ReadInt()
				fileNameLength := file.ReadChar()
				file.Seek(13, 1)
				offset := file.ReadInt()
				fileName := file.Read(fileNameLength)
				if (SubStr(fileName, 0, 1) != "/")
				{
					position := file.Position
					file.Seek(offset, 0)
					localHeader := file.ReadInt()
					if (localHeader = 0x04034b50)
					{
						file.Seek(22, 1)
						fileNameLength := file.ReadChar()
						extraFieldLength := file.ReadChar()
						file.Seek(2, 1)
						fileName := file.Read(fileNameLength)
						StringReplace, fileName, fileName, /, \, All
						extraField := file.Read(extraFieldLength)
						offset := file.Position
						array.Insert({ FileName: fileName, Offset: offset, CompressedSize: compressedSize })
					}
					file.Seek(position, 0)
				}
				pos := -1 * (fileNameLength + 42)
				file.Seek(pos, 1)
			}
			file.Seek(-5, 1)
			i++
		}
		return array
	}
}