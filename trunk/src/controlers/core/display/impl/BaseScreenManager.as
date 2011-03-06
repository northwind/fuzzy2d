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
		private var _container:Sprite;
		private var _current:IScreen;
		
		public function BaseScreenManager()
		{
			super();
		}
		
		public function init( container:Sprite ) : void
		{
			if ( container == null ){
				Logger.error( "BaseCommandManager init : container is null " );
				return;
			}
			
			this._container = container;
		}
		
		public function add( name:String, screen: IScreen ) : void
		{
			this.reg( name, screen );
		}
		
		public function goto(name:String):void
		{
			var tmp:IScreen = this.getItem( name ) as IScreen;
			if ( tmp == null ){
				Logger.warning( "There is no screen named : " + name );
				return;
			}
			
			if ( _current != null ){
				this._container.removeChild( _current as DisplayObject );
			}
			
			_current = tmp;
			
			this._container.addChild( tmp as DisplayObject );
		}
	}
}