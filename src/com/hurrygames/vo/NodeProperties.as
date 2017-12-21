package com.hurrygames.vo
{
	
	/**
	 * Project : LGMapEditer
	 * CityProperties
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class NodeProperties
	{
		
		public var level:int = -1;
		public var owner:int = -1;
		
		/**
		 * 更高的防御
		 */		
		public var fortification:Boolean;
		
		/**
		 * 更强的攻击力 
		 */		
		public var strong_armies:Boolean;
		
		/**
		 * 更快的速度 
		 */		
		public var fast_armies:Boolean;
		
		/**
		 * 是否是塔。 
		 */		
		public var tower:Boolean;
		
		public var isCity:Boolean;
		
		public function NodeProperties()
		{
		}
	}
} 
