package com.hurrygames.grabber.config
{
	
	import com.hurrygames.editElement.PathNode;
	import com.hurrygames.utils.Config;
	
	import flash.geom.Point;
	
	/**
	 * Project : LandGrabbers
	 * Path_count_node
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class Path_count_node extends BaseModel
	{
		/**
		 * 此边的编号 
		 */		
		public var number:int;
		
		/**
		 * 边的半径 
		 */		
		public var radius:Number;
		
		/**
		 * 边的位置 
		 */		
		private var _point:Point;
		public function get point():Point
		{
			if(Config.use1_28Trans)
			{
				if(_point == null)
				{
					return null;
				}
				var p1:Point = new Point(_point.x/1.28,_point.y/1.28);
				return p1;
			}
			return _point;
		}
		public function set point(po:Point):void
		{
			_point = po;
		}
		
		/**
		 * 决定节点的层次，如果层次是2，则将到达此处的军队，放置到最上层。离开之后，在放回,原来层次。 
		 */		
		public var layer:int;
		
		/**
		 * 此处是否是圣地 
		 */		
		public var sanctuary:Boolean;
		
		/**
		 * 此处是否可见 
		 */		
		public var invisible:Boolean;
		
		/**
		 * 和此边相连的边的列表。 
		 */		
		public var edge:Array = [];
		
		/////////////////////////////////////// 此处往下的属性都是用在寻路里的/////////////////////////
		/**
		 * 此点到目标点的最小距离 
		 */		
		public var distance:Number;
		
		/**
		 * 最短路径中的前一个节点。 
		 */		
		public var preNode:Path_count_node;
		
		/**
		 * 寻路中是否已经位于源点的集合。 为了将算法复杂度降低为O(n)；
		 */		
		public var isInSource:Boolean = false;
		
		/////////////////////////////////////// 此处往下的属性都是用在构建连接图里的/////////////////////////
		/**
		 * 此属性用在广度优先遍历的，表示此属性已经遍历过了。 也是为了将算法复杂度降低为O(n)；
		 */		
		public var isPassed:Boolean = false;
		
		/**
		 * 在构建邻接图时，使用此属性判定此节点是不是我的。将算法的复杂度降低为O(n)； 
		 */		
		public var isMine:Boolean = false;
		
		/////////////////////////////////////// 此处往下的属性都是用在节点反查城市里的/////////////////////////
		
		public function Path_count_node(string:String)
		{
			super(string);
		}
		
		public var city:City;
		
		private var _pn:PathNode;
		public function get PN():PathNode
		{
			if(_pn != null)
			{
				
			}else
			{
				_pn = new PathNode();
				_pn.x = point.x;
				_pn.y = -point.y;
				_pn._radius = radius;
				if(city != null)
				{
					_pn.fortification = city.fortification;
					_pn._level = city.level;
					_pn._owner = city.owner;
					_pn.strong_armies = city.strong_armies;
					_pn.fast_armies = city.fast_armies;
					_pn.tower = city.tower;
				}
				_pn.render();
			}
			return _pn;
		}
		
	}
} 
