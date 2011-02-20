package controlers.core.log.impl
{
	import controlers.core.log.ILogWriter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import spark.components.TextArea;
	
	/**
	 * Flex 4.0下使用,	 制定TextArea显示log信息
	 * 
	 * @author norris
	 * 
	 */	
	public class TextAreaWriter implements ILogWriter
	{
		private var container:TextArea;
		
		public function TextAreaWriter( container:TextArea )
		{
			super();
			this.container = container;
		}

		public function writeLog(level:String, content:String):void
		{
			this.container.appendText(  level + " : " + content + "\n" );
		}
	}
}