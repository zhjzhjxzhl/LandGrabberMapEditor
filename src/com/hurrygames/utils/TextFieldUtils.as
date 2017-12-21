package com.hurrygames.utils
{
	import flash.text.TextField;

	public class TextFieldUtils
	{
		public static function fitTextFiled(tf:TextField):void
		{
			tf.width = tf.textWidth+4;
			tf.height = tf.textHeight+4;
		}
		
		public static function setText(tf:TextField,text:String):void
		{
			tf.text = text;
			fitTextFiled(tf);
		}
		
		public static function setTextWithCenter(tf:TextField,text:String):void
		{
			setText(tf,text);
			tf.x = -tf.width/2;
		}
	}
}