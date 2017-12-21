package com.hurrygames.utils
{
	import com.hurrygames.editElement.PathNode;
	
	/**
	 * Project : LGMapEditer
	 * MapDataFormater
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class MapDataFormater
	{
		public function MapDataFormater()
		{
		}
		
		public static function formatFromPNs(pns:Vector.<PathNode>):String
		{
			var cityStr:String = "";
			var pathNStr:String = "";
			
			for(var i:int = 0;i<pns.length;i++)
			{
				pns[i].number = i;
			}
			
			for each(var pn:PathNode in pns)
			{
				if(pn._radius >15)
				{
					cityStr +=("\r\n"+pn.getCityString());
				}
				pathNStr +=("\r\n"+pn.getNodeString());
			}
			
			return (cityStr +"\r\n"+pathNStr);
		}
	}
} 
