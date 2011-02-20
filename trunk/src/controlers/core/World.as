package controlers.core
{
	
	import controlers.core.debug.ICommandManamger;
	import controlers.core.debug.Stats;
	import controlers.core.debug.impl.BaseCommandManager;
	import controlers.core.log.Logger;
	import controlers.core.log.impl.TextAreaWriter;
	import controlers.core.screen.IScreenManager;
	import controlers.core.screen.impl.BaseScreenManager;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * 单例，整个游戏的通用设置，包括物理特性等。 
	 * @author norris
	 * 
	 */	
	public class World
	{
		public var name :String = "2.5d world"; 
		
		private var _area:Sprite;
		private var stats:Sprite;
		
		public var screenMgr:IScreenManager;
		public var commandMgr:ICommandManamger;
		
		public function World()
		{
		}
		
		public function init(  area:Sprite  ) : void
		{
			Logger.info( "world init!" );
			
			this.initManagers();
			
			this._area = area;
			this.stage.addEventListener(Event.ENTER_FRAME, onFrame );
			
			
		}
		
		protected function initManagers() :void
		{
			this.screenMgr = new BaseScreenManager();
			this.commandMgr = new BaseCommandManager();
		}
		
		/**
		 *   显示当前状态  
		 */		
		public function showStats( x : int =0, y : int = 0 ) : void
		{
			if ( !stats ){
				stats =  new Stats( x, y );
				this._area.addChild( stats );
			}
		}
		
		public function hideStats() : void
		{
			if ( stats ){
				this._area.removeChild( stats );
				stats = null;
			}
		}
		
		private function onFrame( event:Event )  : void
		{
			
		}
		
		public function get stage():Stage
		{
			return _area.stage;
		}
		public function get area():Sprite
		{
			return _area;
		}		
	}
}