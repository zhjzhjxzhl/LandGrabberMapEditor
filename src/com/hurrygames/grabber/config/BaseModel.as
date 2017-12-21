package com.hurrygames.grabber.config
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import flashx.textLayout.formats.Float;

	dynamic public class BaseModel
	{
		Animation;
		Animationhost;
//		City;
//		Image;
//		Imagehost;
//		Obstacle;
//		Path_count_node;
//		Player;
//		Warzone;
		
		protected var lineString:String;
		
		public function getLineString():String
		{
			return lineString;
		}
		
		public function BaseModel(string:String)
		{
			lineString = string;
			
			var lines:Array = string.split(new RegExp("\r\n|\n|\r"));
			var line:String;
			for(var i:int = 0;i<lines.length;i++)
			{
				line = lines[i];
				var lp:LineParse = new LineParse(line);
				var nextWord:String;
				nextWord = lp.getNextWord();
				if(nextWord == null)
				{
					continue;
				}
				var name:String = nextWord.substr(1);
				
				switch(nextWord.charAt(0))
				{
					case "@":
						var os:Object = getOneObjectString(lines,(i+1));
						try
						{
							var c:Class = flash.utils.getDefinitionByName("com.hurrygames.grabber.config."+(name.charAt(0).toUpperCase()+name.substr(1))) as Class;
						}catch(e:Error)
						{
							trace(flash.utils.getQualifiedClassName(this)+":"+name+"这个标签不能解析");
							continue;
						}
//						if(this.hasOwnProperty(name))
//						{
							if(this[name] is Array)
							{
								this[name].push(new c(os.ObjectString));
							}else
							{
								this[name] = new c(os.ObjectString);
							}
//						}else
//						{
//							trace("属性没有："+name);
//						}
						i += os.LineNumber;
						
						//解析一个子类。
						break;
					case "#":
						var attributeName:String = lp.getNextWord();
						if(this.hasOwnProperty(attributeName))
						{
							if(this[attributeName] is Array)
							{
								this[attributeName].push(getOneAttribute(name,lp));
							}else
							{
								this[attributeName] = getOneAttribute(name,lp);
							}
							//多个相同名字的属性
							
						}else
						{
							//解析一个属性
							trace(flash.utils.getQualifiedClassName(this)+"没有 "+name+" 属性："+attributeName);
						}
						break;
				}
			}
		}
	
		/**
		 * 解析一个属性 
		 */	
		private function getOneAttribute(type:String,lp:LineParse):Object
		{
			var o:Object;
			switch(type)
			{
				case "string":
					 o = lp.getNextWord();
					break;
				case "point":
					o = new Point(Number(lp.getNextWord()),Number(lp.getNextWord()));
					break;
				case "int":
					o = int(lp.getNextWord());
					break;
				case "float":
					o = Number(lp.getNextWord());
					break;
				case "bool":
					o = (lp.getNextWord() == "true");
					break;
				case "rect":
					o = new Rectangle(Number(lp.getNextWord()),Number(lp.getNextWord()),Number(lp.getNextWord()),Number(lp.getNextWord()));
					break;
				default:
					trace(lp.line + "不能解析");
					break;
				
			}
			return o;
		}
		
		/**
		 * 根据当前索引，取出当前object对应的行的字符串描述。 
		 */	
		private function getOneObjectString(lines:Array,index:int):Object
		{
			var j:int = 0;
			var objectString:String = "";
			var find:Boolean = false;
			var kuohao:int = 0;
			for(var i:int = index;i<lines.length;i++)
			{
				j++;
				var line:String = lines[i];
				for(var k:int = 0;k<line.length;k++)
				{
					if(line.charAt(k) == "{")
					{
						find = true;
						kuohao++;
					}
					if(line.charAt(k) == "}")
					{
						kuohao--;
					}
				}
				objectString += (line + "\r\n");
				if(find && (kuohao==0))
				{
					break;
				}
			}
			return {"LineNumber":j,"ObjectString":objectString};
		}
	}
}