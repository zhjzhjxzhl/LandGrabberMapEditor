package com.hurrygames.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * Project : LGMapEditer
	 * DialogueManager
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class DialogueManager
	{
		private var grayMask:Sprite;
		
		private var _dialogueLayer:Sprite = new Sprite();
		
		public function get dialogueLayer():Sprite
		{
			return _dialogueLayer;
		}
		public function set dialogueLayer(dis:Sprite):void
		{
			_dialogueLayer = dis;
		}
		
		private static var _instance:DialogueManager;
		public static function get instance():DialogueManager
		{
			if(_instance == null)
			{
				_instance = new DialogueManager();
			}
			return _instance;
		}
		public function DialogueManager()
		{
			grayMask = new Sprite();
			grayMask.graphics.beginFill(0x333333,0.5);
			grayMask.graphics.drawRect(0,0,Config.WIDTH,Config.HEIGHT);
			grayMask.graphics.endFill();
		}
		
		public function showDialogue(dialogue:Sprite):void
		{
			if(_dialogueLayer != null)
			{
				_dialogueLayer.addChild(grayMask);
				dialogue.x = (Config.WIDTH-dialogue.width)/2;
				dialogue.y = (Config.HEIGHT-dialogue.height)/2;
				_dialogueLayer.addChild(dialogue);
			}
		}
		
		public function closeDialogue():void
		{
			while(_dialogueLayer.numChildren>0)
			{
				_dialogueLayer.removeChildAt(0);
			}
		}
	}
} 
