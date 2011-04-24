package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.core.display.ILayer;
	import com.norris.fuzzy.core.display.IScreen;
	import com.norris.fuzzy.core.display.IScreenManager;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class BaseScreenManager extends BaseComponent implements IScreenManager
	{
		private var _container:Sprite = new Sprite();
		private var _current:IScreen;
		private var _items:BaseManager = new BaseManager();
		
		public function BaseScreenManager( ct:Sprite )
		{
			super();
			
			ct.addChild( this._container );
		}
		
		public function add( name:String, screen: IScreen ) : void
		{
			this._items.reg( name, screen );
		}
		
		public function get( name:String ) :IScreen
		{
			return this._items.find( name ) as IScreen;
		}
		
		public function remove( name:String ) :void
		{
			this._items.unreg( name );
		}
		
		public function goto(name:String):void
		{
			var tmp:IScreen = this._items.find( name ) as IScreen;
			if ( tmp == null ){
				Logger.warning( "There is no screen named : " + name );
				return;
			}
			
			// only show one screen
			if ( _current != null ){
				try{
					this._container.removeChild( _current.view );
				}catch(e :Error ){}
			}
			
			_current = tmp;
			
			this._container.addChild( tmp.view );
		}
	}
}