package controlers.core
{
	
	import controlers.core.cop.impl.Entity;
	import controlers.core.debug.IDebugManamger;
	import controlers.core.debug.impl.BaseDebugManager;
	import controlers.core.display.IScreenManager;
	import controlers.core.display.impl.BaseScreenManager;
	import controlers.core.input.IInputManager;
	import controlers.core.input.impl.InputKey;
	import controlers.core.input.impl.InputManager;
	import controlers.core.log.Logger;
	import controlers.core.log.impl.TextAreaWriter;
	import controlers.core.resource.IResourceManager;
	import controlers.core.resource.impl.ResourceManager;
	import controlers.core.sound.ISounderManager;
	import controlers.core.sound.impl.SounderManager;
	
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
	public class World extends Entity
	{
		public var name :String = "2.5d world"; 
		
		private var _area:Sprite;
		private var stats:Sprite;
		
		public var screenMgr:IScreenManager;
		public var inputMgr:IInputManager;
		public var resourceMgr:IResourceManager;
		public var soundMgr:ISounderManager;

		protected var debugMgr:IDebugManamger;
		
		public function World()
		{
		}
		
		public function init(  area:Sprite  ) : void
		{
			Logger.info( "world init!" );
			
			this._area = area;
			
			var myContextMenu:ContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();
			this._area.contextMenu = myContextMenu;
				
			this.initManagers();
			
			this.stage.addEventListener(Event.ENTER_FRAME, onFrame );
		}
		
		protected function initManagers() :void
		{
			this.inputMgr  = new InputManager( this._area );
			this.screenMgr = new BaseScreenManager( this._area );
			this.debugMgr = new BaseDebugManager( this._area );
			this.resourceMgr = new ResourceManager();
			this.soundMgr = new SounderManager();
			
			this.addComponent( this.inputMgr );
			this.addComponent( this.debugMgr );
			this.addComponent( this.resourceMgr );
			this.addComponent( this.soundMgr );
			this.addComponent( this.screenMgr );
			
			this.setup();
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