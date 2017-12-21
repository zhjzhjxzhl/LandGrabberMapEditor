package
{
	import com.hurrygames.editElement.NodeLink;
	import com.hurrygames.editElement.PathNode;
	import com.hurrygames.grabber.config.BaseModel;
	import com.hurrygames.grabber.config.City;
	import com.hurrygames.grabber.config.Path_count_node;
	import com.hurrygames.grabber.config.Warzone;
	import com.hurrygames.utils.Config;
	import com.hurrygames.utils.DialogueManager;
	import com.hurrygames.utils.MapDataFormater;
	import com.hurrygames.utils.TextFieldUtils;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import flashx.textLayout.elements.LinkElement;
	
	[SWF(width="1280",height="768",frameRate="60")]
	public class LGMapEditer extends Sprite
	{
		public static function get instance():LGMapEditer
		{
			return _instance;
		}
		
		private static var _instance:LGMapEditer;
		/**
		 * ui层 
		 */		
		public var uiLayer:Sprite;
		/**
		 * 背景图片层 
		 */		
		public var backMapLayer:Sprite;
		/**
		 *画布层 
		 */
		public var canveLayer:Sprite;
		
		/**
		 * 节点层 
		 */		
		public var nodeLayer:Sprite = new Sprite();;
		
		/**
		 *连接层 
		 */		
		public var linkLayer:Sprite = new Sprite();;
		
		private var _statu:TextField = new TextField();
		/**
		 *所有路径上的点 
		 */		
		public var _pathNodes:Vector.<PathNode> = new Vector.<PathNode>();
		/**
		 *当前正在操作的这个link 
		 */		
		public var currentLink:NodeLink;
		
		public var _warzone:Warzone;
		
		public function LGMapEditer()
		{
			_instance = this;
			uiLayer = new Sprite();
			backMapLayer = new Sprite();
			backMapLayer.graphics.beginFill(0xaaaaaa,0.5);
			backMapLayer.graphics.drawRect(0,0,1000,600);
			backMapLayer.graphics.endFill();
			backMapLayer.y = 50;
//			backMapLayer.mouseChildren = backMapLayer.mouseEnabled = false;
			canveLayer = new Sprite();
			canveLayer.y = 50;
			canveLayer.mouseEnabled = false;
			
			canveLayer.addChild(linkLayer);
			canveLayer.addChild(nodeLayer);
			linkLayer.x = Config.WIDTH/2;
			linkLayer.y = Config.HEIGHT/2;
			nodeLayer.x = linkLayer.x;
			nodeLayer.y = linkLayer.y;
			nodeLayer.mouseEnabled = linkLayer.mouseEnabled = false;
			this.addChild(backMapLayer);
			this.addChild(canveLayer);
			this.addChild(uiLayer);
			
			this.addChild(DialogueManager.instance.dialogueLayer);
			
			var loadMap:TextField = new TextField();
			TextFieldUtils.setText(loadMap,"加载地图");
			loadMap.selectable = false;
			uiLayer.addChild(loadMap);
			loadMap.addEventListener(MouseEvent.CLICK,loadmap);
			
			var loadLevelConfig:TextField = new TextField();
			TextFieldUtils.setText(loadLevelConfig,"地图配置");
			loadLevelConfig.selectable = false;
			loadLevelConfig.x = 60;
			uiLayer.addChild(loadLevelConfig);
			loadLevelConfig.addEventListener(MouseEvent.CLICK,loadLevel);
			
			var saveLevelConfig:TextField = new TextField();
			TextFieldUtils.setText(saveLevelConfig,"保存地图");
			saveLevelConfig.selectable = false;
			saveLevelConfig.x = 120;
			uiLayer.addChild(saveLevelConfig);
			saveLevelConfig.addEventListener(MouseEvent.CLICK,saveLevel);
			
			var use1_28Trans:TextField = new TextField();
			TextFieldUtils.setText(use1_28Trans,"开启1.28倍缩放");
			use1_28Trans.selectable = false;
			use1_28Trans.x = 180;
			uiLayer.addChild(use1_28Trans);
			use1_28Trans.addEventListener(MouseEvent.CLICK,changeTrans);
			
			
//			var addNode:TextField = new TextField();
//			TextFieldUtils.setText(addNode,"添加一个节点");
//			addNode.selectable = false;
//			addNode.x = 60;
//			uiLayer.addChild(addNode);
//			addNode.addEventListener(MouseEvent.CLICK,addOneNode);
			
			var addNodeMenu:ContextMenuItem = new ContextMenuItem("添加节点");
			
			addNodeMenu.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,addOneNode);
			var cm:ContextMenu = new ContextMenu();
			cm.customItems.push(addNodeMenu);
			
			backMapLayer.contextMenu = cm;
			
			_statu.y = 20;
			TextFieldUtils.setText(_statu,"当前操作状态");
			uiLayer.addChild(_statu);
			_statu.mouseEnabled = _statu.selectable = false;
			
		}
		
		protected function changeTrans(event:MouseEvent):void
		{
			var t:TextField = event.target as TextField;
			if(!Config.use1_28Trans)
			{
				Config.use1_28Trans = true;
				t.filters = [new GlowFilter(0xffff00,1,4,4,16)];
			}else
			{
				Config.use1_28Trans = false;
				t.filters = [];
			}
		}
		
		protected function saveLevel(event:MouseEvent):void
		{
			var savefile:File = new File();
			savefile.browseForSave("保存地图为txt文件");
			savefile.addEventListener(Event.SELECT,saveLevelConfirm);
		}
		
		protected function saveLevelConfirm(event:Event):void
		{
			var file:File = event.target as File;
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			var s:String = MapDataFormater.formatFromPNs(_pathNodes);
			trace(s);
			fs.writeUTFBytes(s);
			fs.close();
		}
		
		protected function loadLevel(event:MouseEvent):void
		{
			var config:File = new File();
			config.browseForOpen("加载地图配置",[new FileFilter("文本","*.txt")]);
			config.addEventListener(Event.SELECT,loadLevelConfig);
		}
		
		protected function loadLevelConfig(event:Event):void
		{
			var map:File = event.target as File;
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(map.nativePath));
			loader.addEventListener(Event.COMPLETE,levelConfigFinished);
		}
		
		protected function levelConfigFinished(event:Event):void
		{
			var model:BaseModel = new BaseModel((event.target as URLLoader).data);
			_warzone = model.warzone;
			deleteSamePCN();
			deleteSameEdge();
			initCityPNode(_warzone);
			drawPath(_warzone);
		}
		
		private function deleteSamePCN():void
		{
			var seed:Vector.<int> = new Vector.<int>();
			for each(var pcn:Path_count_node in _warzone.path_count_node)
			{
				if(seed.indexOf(pcn.number) == -1)
				{
					seed.push(pcn.number);
				}else
				{
					_warzone.path_count_node.splice(_warzone.path_count_node.indexOf(pcn),1);
				}
			}
		}
		
		private function deleteSameEdge():void
		{
			for each(var pcn:Path_count_node in _warzone.path_count_node)
			{
				pcn.edge = ds(pcn.edge);
			}
		}
		private function ds(arr:Array):Array
		{
			var result:Array = [];
			for each(var ob:* in arr)
			{
				if(result.indexOf(ob) == -1)
				{
					result.push(ob);
				}
			}
			return result;
		}
		
		protected function addOneNode(event:Event):void
		{
			var node:PathNode = new PathNode();
			node.x = nodeLayer.mouseX;
			node.y = nodeLayer.mouseY;
			nodeLayer.addChild(node);
			_pathNodes.push(node);
		}
		
		protected function loadmap(event:Event):void
		{
			var map:File = new File();
			map.browseForOpen("加载背景地图",[new FileFilter("Images","*.png")]);
			map.addEventListener(Event.SELECT,loadMap);
		}
		
		protected function loadMap(event:Event):void
		{
			while(backMapLayer.numChildren>0)
			{
				backMapLayer.removeChildAt(0);
			}
			var map:File = event.target as File;
			var loader:Loader = new Loader();
			loader.load(new URLRequest(map.nativePath));
			backMapLayer.addChild(loader);
			loader.mouseChildren = loader.mouseEnabled = false;
		}
		
		/**
		 *到达过的节点，关闭列表 
		 */
		private var usedNodes:Vector.<int>;
		/**
		 * 新加入的节点，开放列表
		 */
		private var openNodes:Vector.<int>;
		private function drawPath(wz:Warzone):void
		{
			usedNodes = new Vector.<int>();
			openNodes = new Vector.<int>();
			for each(var pn:Path_count_node in wz.path_count_node)
			{
				openNodes.push(pn.number);
			}
			drawNode();
		}
		
		private function drawNode():void
		{
			while(openNodes.length>0)
			{
				var currentId:int = openNodes.shift();
				if(usedNodes.indexOf(currentId) != -1)
				{
					continue;
				}
				var pn:Path_count_node = _warzone.getPCNbyId(currentId);
				var pnnn:PathNode = pn.PN;
				usedNodes.push(pn.number);
				nodeLayer.addChild(pnnn);
				_pathNodes.push(pnnn);
				if(pnnn._radius>15)
				{
					if(pnnn._owner==1)
					{
						trace("my");
					}
					trace(pnnn._owner);
				}
				for each(var pnn:int in pn.edge)
				{
					if(usedNodes.indexOf(pnn) != -1)
					{
						continue;
					}
					var pcn:Path_count_node = _warzone.getPCNbyId(pnn);
					var link:NodeLink = new NodeLink(pnnn);
					link.node2 = pcn.PN;
					pnnn.edges.push(link);
					pcn.PN.edges.push(link);
					linkLayer.addChild(link);
					link.startTraceMouse();
					if(openNodes.indexOf(pnn) == -1)
					{
						openNodes.push(pnn);
					}
				}
			}
		}
		
		/**
		 *初始化下city和path_count_node的融合 
		 * @param wz
		 * 
		 */		
		private function initCityPNode(wz:Warzone):void
		{
			for each(var city:City in wz.city)
			{
				for each(var pn:Path_count_node in wz.path_count_node)
				{
					if(pn.number == city.count_node_number)
					{
						pn.city = city;
						break;
					}
				}
			}
		}
	}
}