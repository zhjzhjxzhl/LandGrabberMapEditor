package com.hurrygames.grabber.config
{
	import flash.geom.Point;
	
	/**
	 * Project : LandGrabbers
	 * WarZone
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class Warzone extends BaseModel
	{
		/**
		 * 名字 
		 */		
		public var name:String;
		
		public var pos:Point;
		
		/**
		 * 场景大小 
		 */		
		public var size:Point;
		
		
		/**
		 * 战场背景音乐 
		 */
		public var music_name:String;
		
		/**
		 * 环境音乐 
		 */		
		public var ambient_name:String;
		
		/**
		 *战场背景 
		 */		
		public var background_texture:String;
		
		/**
		 *战场建筑最大级别 
		 */		
		public var max_upgrade_level:int;
		
		/**
		 * 额外攻击理 
		 */		
		public var bonus_attack:Number;
		
		/**
		 * 额外防御力 
		 */		
		public var bonus_defence:Number;
		
		/**
		 * 额外的速度 
		 */		
		public var bonus_speed:Number;
		
		/**
		 *需要的客户端数 
		 */		
		public var needed_clients:int;
		
		/**
		 * 专家消耗的时间 
		 */		
		public var trophy_time_normal:Number;
		
		public var trophy_time_hard:Number;
		
		public var trophy_time_expert:Number;
		
		public var trophy_time:Number;
		
		/**
		 * 玩家数组 
		 */		
		public var player:Array = [];
		
		/**
		 * 城市数组 
		 */		
		public var city:Array = [];
		
		/**
		 * 动态资源数组 
		 */		
		public var obstacle:Array = [];
		
		/**
		 * 路径节点数组 
		 */		
		public var path_count_node:Array = [];
		
		public function Warzone(string:String)
		{
			super(string);
		}
		
		public function getPCNbyId(id:int):Path_count_node
		{
			for each(var pn:Path_count_node in path_count_node)
			{
				if(pn.number == id)
				{
					return pn;
				}
			}
			return null;
		}
	}
} 
