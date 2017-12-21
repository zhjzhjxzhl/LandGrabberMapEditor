package com.hurrygames.editElement
{
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class NodeLink extends Sprite
	{
		
		public var node1:PathNode;
		
		public var node2:PathNode;
		
		public function NodeLink(node1:PathNode)
		{
			super();
			this.node1 = node1;
			
			var removeMenu:ContextMenuItem = new ContextMenuItem("移除此连接");
			removeMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,removeLink);
			var cm:ContextMenu = new ContextMenu();
			cm.customItems.push(removeMenu);
			this.contextMenu = cm;
			
			this.graphics.lineStyle(4,0xffff00);
			this.graphics.lineTo(0,10);
		}
		
		protected function removeLink(event:ContextMenuEvent):void
		{
			this.destory();
		}
		
		public function startTraceMouse():void
		{
			this.addEventListener(Event.ENTER_FRAME,tick);
		}
		
		protected function tick(event:Event):void
		{
			this.x = node1.x;
			this.y = node1.y;
			
			if(this.stage != null)
			{
				var localP:Point;
				if(this.node2 != null)
				{
					var pp:Point = node2.localToGlobal(new Point());
					localP = this.globalToLocal(pp);
				}else
				{
					var mouseP:Point = new Point(this.stage.mouseX,this.stage.mouseY);
					localP = this.globalToLocal(mouseP);
				}
				this.graphics.clear();
				this.graphics.lineStyle(4,0xffff00);
				this.graphics.lineTo(localP.x,localP.y);
			}
		}
		
		public function stopTraceMouse():void
		{
			this.removeEventListener(Event.ENTER_FRAME,tick);
		}
		
		public function destory():void
		{
			if(this.parent != null)
			{
				this.parent.removeChild(this);
			}
			stopTraceMouse();
			if(node1 != null)
			{
				if(node1.edges.indexOf(this) != -1)
				{
					node1.edges.splice(node1.edges.indexOf(this),1);
				}
			}
			if(node2 != null)
			{
				if(node2.edges.indexOf(this) != -1)
				{
					node2.edges.splice(node2.edges.indexOf(this),1);
				}
			}
		}
	}
}