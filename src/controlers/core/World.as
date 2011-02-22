package controlers.core
{
	
	import controlers.core.debug.IDebugManamger;
	import controlers.core.debug.Stats;
	import controlers.core.debug.impl.BaseDebugManager;
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
		
		[Inject]
		public var screenMgr:IScreenManager;
		[Inject]
		public var commandMgr:IDebugManamger;
		
		public function World()
		{
		}
		
		public function init(  area:Sprite  ) : void
		{
			Logger.info( "world init!" );
			
			this._area = area;
			
			this.initManagers();
			
			this.stage.addEventListener(Event.ENTER_FRAME, onFrame );
		}
		
		protected function initManagers() :void
		{
//			this.screenMgr
			this.commandMgr.init( this._area );
			this.commandMgr.registerCommand( "fpson", this.showStats, "show fps indicator at [x,y]." );
			this.commandMgr.registerCommand( "fpsoff", this.hideStats, "hide fps indicator." );
		}
		
		/**
		 *   显示当前状态  
		 */		
		public function showStats( sx : String = "0", sy : String = "0" ) : void
		{
			var x:int = parseInt( sx );
			var y:int = parseInt( sy );
			
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