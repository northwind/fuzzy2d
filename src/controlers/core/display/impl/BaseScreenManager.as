package controlers.core.display.impl
{
	import controlers.core.display.ILayer;
	import controlers.core.display.IScreen;
	import controlers.core.display.IScreenManager;
	import controlers.core.log.Logger;
	import controlers.core.manager.impl.BaseManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class BaseScreenManager extends BaseManager implements IScreenManager
	{
		private var _container:Sprite = new Sprite();
		private var _current:IScreen;
		
		public function BaseScreenManager()
		{
			super();
		}
		
		public function init( ct:Sprite ) : void
		{
			if ( ct == null ){
				Logger.error( "BaseCommandManager init : ct is null " );
				return;
			}
			
			ct.addChild( this._container );
		}
		
		public function add( name:String, screen: IScreen ) : void
		{
			this.reg( name, screen );
		}
		
		public function get( name:String ) :IScreen
		{
			return this.find( name ) as IScreen;
		}
		
		public function remove( name:String ) :void
		{
			this.unreg( name );
		}
		
		public function goto(name:String):void
		{
			var tmp:IScreen = this.find( name ) as IScreen;
			if ( tmp == null ){
				Logger.warning( "There is no screen named : " + name );
				return;
			}
			
			// only show one screen
			if ( _current != null ){
				this._container.removeChild( _current as DisplayObject );
			}
			
			_current = tmp;
			
			this._container.addChild( tmp as DisplayObject );
		}
	}
}