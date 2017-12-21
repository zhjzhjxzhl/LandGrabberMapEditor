package com.hurrygames.utils
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * Project : test
	 * BaseObject
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class BaseUI extends Sprite
	{
		public function BaseUI()
		{
			if(this.stage)
			{
				_init();
			}else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,_init);
			}
		}
		private function _init(e:Event=null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,_init);
			this.addEventListener(Event.REMOVED_FROM_STAGE,_removeHandler);
			init();
		}
		
		private function _removeHandler(e:Event = null):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,_removeHandler);
			destory();
		}
		
		/**
		 *初始化函数。覆盖此函数 
		 * 
		 */		
		protected function init():void
		{
			trace(flash.utils.getQualifiedClassName(this)+"初始化。。。");
		}
		
		/**
		 *从场景移除时，清理资源的函数。 
		 * 
		 */		
		protected function destory():void
		{
			trace(flash.utils.getQualifiedClassName(this)+"从场景移除。。。");
		}
	}
} 
