package com.hurrygames.editElement
{
	import com.hurrygames.utils.DialogueManager;
	import com.hurrygames.utils.TextFieldUtils;
	import com.hurrygames.views.NodePropertyHelper;
	import com.hurrygames.vo.NodeProperties;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class PathNode extends Sprite
	{
		public var number:int = -1;
		
		public var _radius:int = 10;
		
		public var point:Point = new Point();
		
		public var layer:int = 0;
		
		public var sanctuary:Boolean = false;
		
		public var invisible:Boolean = false;
		
		/**
		 * 节点之间的连接
		 */	
		public var edges:Vector.<NodeLink> = new Vector.<NodeLink>();
		
		/////以下是城市的属性
		public var _level:int = -1;
		public var _owner:int = -1;
		
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
		
		
		
		//////////////
		private var _des:TextField = new TextField();
		
		
		public function PathNode()
		{
			super();
			render();
			initListeners();
			_des.mouseEnabled = _des.selectable = false;
		}
		
		private function initListeners():void
		{
			var changePropertiesMenu:ContextMenuItem = new ContextMenuItem("修改属性");
			var addLinkMenu:ContextMenuItem = new ContextMenuItem("添加一个连接");
			var endLinkMenu:ContextMenuItem = new ContextMenuItem("以此作为连接的终点");
			var delNodeMenu:ContextMenuItem = new ContextMenuItem("删除此节点");
			
			changePropertiesMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,changeProperty);
			addLinkMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,addLink);
			endLinkMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,endLink);
			delNodeMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,deleteNode);
			
			var cm:ContextMenu = new ContextMenu();
			
			cm.customItems.push(changePropertiesMenu);
			cm.customItems.push(addLinkMenu);
			cm.customItems.push(endLinkMenu);
			cm.customItems.push(delNodeMenu);
			
			this.contextMenu = cm;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,startMove);
			this.addEventListener(MouseEvent.MOUSE_UP,stopMove);
		}
		
		protected function deleteNode(event:ContextMenuEvent):void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			if(LGMapEditer.instance._pathNodes.indexOf(this) != -1)
			{
				LGMapEditer.instance._pathNodes.splice(LGMapEditer.instance._pathNodes.indexOf(this),1);
			}
			while(edges.length>0)
			{
				edges[0].destory();
			}
		}
		
		protected function changeProperty(event:ContextMenuEvent):void
		{
			var nph:NodePropertyHelper = new NodePropertyHelper(setProperties,this);
			DialogueManager.instance.showDialogue(nph);
		}
		
		protected function endLink(event:ContextMenuEvent):void
		{
			if(LGMapEditer.instance.currentLink != null)
			{
				LGMapEditer.instance.currentLink.node2 = this;
				var have:Boolean = false;
				for each(var link:NodeLink in this.edges)
				{
					if((link.node1==LGMapEditer.instance.currentLink.node1 && link.node2 == LGMapEditer.instance.currentLink.node2)||
						(link.node1 == LGMapEditer.instance.currentLink.node2 && link.node2 == LGMapEditer.instance.currentLink.node1))
					{
						have = true;
					}
				}
				if(!have)
				{
					this.edges.push(LGMapEditer.instance.currentLink);
				}
				
				LGMapEditer.instance.currentLink = null;
			}
		}
		
		protected function addLink(event:ContextMenuEvent):void
		{
			if(LGMapEditer.instance.currentLink != null)
			{
				LGMapEditer.instance.currentLink.destory();
				LGMapEditer.instance.currentLink = null;
			}
			var link:NodeLink = new NodeLink(this);
			link.x = this.x;
			link.y = this.y;
			LGMapEditer.instance.linkLayer.addChild(link);
			edges.push(link);
			link.startTraceMouse();
			LGMapEditer.instance.currentLink = link;
		}
		
		protected function stopMove(event:Event):void
		{
			this.stopDrag();
			event.stopPropagation();
		}
		
		protected function startMove(event:Event):void
		{
			this.startDrag(true);
			event.stopPropagation();
		}
		
		public static const colors:Array = [0xff00ff,0x0000ff,0xff0000,0x00ff00,0xffff00];
		
		public function render():void
		{
			this.graphics.clear();
			this.graphics.beginFill((_radius >15)?colors[_owner]:0x666666);
			this.graphics.drawCircle(0,0,_radius);
			this.graphics.endFill();
			if(_radius >15)
			{
				this.addChild(_des);
				var des:String = "等级:"+_level.toString()+" | 玩家:"+_owner.toString();
				if(fortification)
				{
					des += "|城堡";
				}
				if(strong_armies)
				{
					des += "|铁匠铺";
				}
				if(fast_armies)
				{
					des += "|马厩";
				}
				if(tower)
				{
					des += "|塔";
				}
				TextFieldUtils.setTextWithCenter(_des,des);
			}else
			{
				if(_des.parent == this)
				{
					this.removeChild(_des);
				}
			}
		}
		
		public function setProperties(np:NodeProperties):void
		{
			_radius = np.isCity?20:10;
			if(np.isCity)
			{
				_level = np.level;
				_owner = np.owner;
				fortification = np.fortification;
				strong_armies = np.strong_armies;
				fast_armies = np.fast_armies;
				tower = np.tower;
			}else
			{
				_level = -1;
				_owner = -1;
				fortification = false;
				strong_armies = false;
				fast_armies = false;
				tower = false;
			}
			render();
		}
		
		/**
		 *獲取城市的字符串 
		 * @return 
		 * 
		 */
		public function getCityString():String
		{
			var str:String = "";
			str += "\t@city\r\n";
			str += "\t{\r\n";
			str += "\t\t#string name \"town"+number.toString()+"\";\r\n";
			str += "\t\t#point pos " +this.x.toString() +", "+(-this.y).toString()+";\r\n";
			str += "\t\t#int start_population "+(_level*10).toString()+";\r\n";
			str += "\t\t#int level "+_level.toString()+";\r\n";
			str += "\t\t#int owner "+_owner.toString()+";\r\n";
			str += "\t\t#point tower_range 100, 100;\r\n";
			str += "\t\t#int layer 0;\r\n";
			str += "\t\t#int count_node_number "+number.toString()+";\r\n";
			str += "\t\t#bool fortification "+fortification.toString()+";\r\n";
			str += "\t\t#bool strong_armies "+strong_armies.toString()+";\r\n";
			str += "\t\t#bool fast_armies "+fast_armies.toString()+";\r\n";
			str += "\t\t#bool tower "+tower.toString()+";\r\n";
			str += "\t}";
			
			return str;
		}
		
		/**
		 *获取node的字符串 
		 * @return 
		 * 
		 */
		public function getNodeString():String
		{
			var str:String = "";
			str += "\t@path_count_node\r\n";
			str += "\t{\r\n";
			str += "\t\t#int number "+number.toString()+";\r\n";
			str += "\t\t#float radius "+_radius.toString()+";\r\n";
			str += "\t\t#point point "+this.x.toString()+", "+(-this.y).toString()+";\r\n";
			str += "\t\t#int layer 0;\r\n";
			str += "\t\t#bool sanctuary "+sanctuary.toString()+";\r\n";
			str += "\t\t#bool invisible "+invisible.toString()+";\r\n";
			for each(var link:NodeLink in edges)
			{
				var other:PathNode;
				if(link.node1 == this)
				{
					other = link.node2;
				}else
				{
					other = link.node1;
				}
				str +="\t\t#int edge "+other.number.toString()+";\r\n";
			}
			str += "\t}";
			return str;
		}
	}
}