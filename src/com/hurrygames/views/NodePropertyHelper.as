package com.hurrygames.views
{
	import com.hurrygames.LGMapEditer.swc.panel.NodeProperty;
	import com.hurrygames.editElement.PathNode;
	import com.hurrygames.utils.BaseUI;
	import com.hurrygames.utils.DialogueManager;
	import com.hurrygames.vo.NodeProperties;
	
	import flash.events.MouseEvent;
	
	
	/**
	 * Project : LGMapEditer
	 * NodePropertyHelper
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class NodePropertyHelper extends BaseUI
	{
		private var _ok_callBack:Function;
		
		private var _np:NodeProperty;
		public function NodePropertyHelper(callBack:Function,pn:PathNode)
		{
			super();
			_ok_callBack = callBack;
			_np = new NodeProperty();
			this.addChild(_np);
			
			if(pn._radius >= 15)
			{
				//说明是城市，填上默认值
				_np.txt_isCity.text = "1";
				_np.txt_level.text = pn._level.toString();
				_np.txt_owner.text = pn._owner.toString();
				_np.txt_isFast.text = pn.fast_armies?"1":"0";
				_np.txt_isfortification.text = pn.fortification?"1":"0";
				_np.txt_isStrong.text = pn.strong_armies?"1":"0";
				_np.txt_isTower.text = pn.tower?"1":"0";
			}
		}
		
		override protected function destory():void
		{
			_np.btn_ok.removeEventListener(MouseEvent.CLICK,ok);
			_np.btn_cancle.removeEventListener(MouseEvent.CLICK,cancle);
		}
		
		override protected function init():void
		{
			_np.btn_ok.addEventListener(MouseEvent.CLICK,ok);
			_np.btn_cancle.addEventListener(MouseEvent.CLICK,cancle);
		}
		
		protected function ok(event:MouseEvent):void
		{
			var np:NodeProperties = new NodeProperties();
			np.level = int(_np.txt_level.text);
			np.owner = int(_np.txt_owner.text);
			np.fast_armies = (_np.txt_isFast.text == "1");
			np.fortification = (_np.txt_isfortification.text == "1");
			np.isCity = (_np.txt_isCity.text == "1");
			np.strong_armies = (_np.txt_isStrong.text == "1");
			np.tower = (_np.txt_isTower.text == "1");
			
			_ok_callBack.apply(null,[np]);
			DialogueManager.instance.closeDialogue();
		}
		
		protected function cancle(event:MouseEvent):void
		{
			DialogueManager.instance.closeDialogue();
		}
		
	}
} 
