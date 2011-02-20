package controlers.core.debug.impl
{
	import controlers.core.debug.IConsole;
	import controlers.core.display.impl.BaseDisplay;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BaseConsole extends BaseDisplay implements IConsole
	{
		public function BaseConsole()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			graphics.beginFill(0x33);
			graphics.drawRect(0, 0, 80, 40);
			graphics.endFill();
		}
		
		public function writeLine(content:String):void
		{
		}
		
		public function clear():void
		{
		}
		
		public function getContent():String
		{
			return null;
		}
	}
}