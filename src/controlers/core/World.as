package controlers.core
{
	
	import controlers.core.debug.IDebugManamger;
	import controlers.core.debug.Stats;
	import controlers.core.debug.impl.BaseDebugManager;
	import controlers.core.display.IScreenManager;
	import controlers.core.display.impl.BaseScreenManager;
	import controlers.core.input.IInputManager;
	import controlers.core.input.impl.InputKey;
	import controlers.core.log.Logger;
	import controlers.core.log.impl.TextAreaWriter;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	
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
		[Inject]
		public var inputMgr:IInputManager;
		
		public function World()
		{
		}
		
		public function init(  area:Sprite  ) : void
		{
			Logger.info( "world init!" );
			
			this._area = area;
			
			var myContextMenu:ContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
			var item:ContextMenuItem = new ContextMenuItem( "意见反馈" );
			myContextMenu.customItems.push(item);
			this._area.contextMenu = myContextMenu;
				
			this.initManagers();
			
			this.stage.addEventListener(Event.ENTER_FRAME, onFrame );
		}
		
		protected function initManagers() :void
		{
			this.screenMgr.init( this._area );
			
			this.commandMgr.init( this._area );
			this.commandMgr.registerCommand( "fps", this.showStats, "show/hide fps indicator at [x,y]." );
			
			this.inputMgr.init( this._area );
			this.inputMgr.on( InputKey.F12, function ( event:Event ): void{
				commandMgr.toggle();
			});
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