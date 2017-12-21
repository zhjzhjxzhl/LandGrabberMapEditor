package com.hurrygames.grabber.config
{
	/**
	 * 解析一行。 
	 * @author Administrator
	 * 
	 */	
	public class LineParse
	{
		private var _line:String;
		public static const r:RegExp = new RegExp("\t|;|,|\"| |\r");
		
		private var words:Array = [];
		
		public function LineParse(line:String)
		{
			_line = line;
			words = _line.split(r);
		}
		
		public function getNextWord():String
		{
			if(words.length == 0)
			{
				return null;
			}
			while(words[0] == "")
			{
				words.shift();
				if(words.length == 0)
				{
					return null;
				}
			}
			return words.shift();
		}
		
		public function get line():String
		{
			return _line;
		}
	}
}