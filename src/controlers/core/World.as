package controlers.core
{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import controlers.core.debug.Stats;
	
	/**
	 * 单例，整个游戏的通用设置，包括物理特性等。 
	 * @author norris
	 * 
	 */	
	public class World
	{
		public var name :String = "2.5d world"; 
		
		private var area:Sprite;
		private var stats:Sprite;
		
		public function World()
		{
		}
		
		public function init(  area:Sprite  ) : void
		{
			this.area = area;
			
			this.stage.addEventListener(Event.ENTER_FRAME, onFrame );		
		}
		
		/**
		 *   显示当前状态  
		 */		
		public function showStats( x : int =0, y : int = 0 ) : void
		{
			if ( !stats ){
				stats =  new Stats( x, y );
				this.area.addChild( stats );
			}
		}
		
		public function hideStats() : void
		{
			if ( stats ){
				this.area.removeChild( stats );
				stats = null;
			}
		}
		
		private function onFrame( event:Event )  : void
		{
			
		}
		
		public function get stage():Stage
		{
			return area.stage;
		}
		
	}
}