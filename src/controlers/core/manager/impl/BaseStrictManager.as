package controlers.core.manager.impl
{
	import controlers.core.manager.IItem;
	import controlers.core.manager.IStrictManager;
	import controlers.core.manager.events.ManagerEvent;
	import controlers.core.log.Logger;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class BaseStrictManager extends EventDispatcher implements IStrictManager
	{
		private var items:Dictionary = new Dictionary();
		private var _count:int = 0;
		
		public function BaseStrictManager()
		{
		}
		
		public function reg(key:String, item:IItem ):void
		{
			if ( key == null || key == "" ){
				return;
			}
			if ( item == null ){
				Logger.warning( "BaseStrictManager reg " + key + " : item is null." );
				return;
			}
			
			if ( !has( key ) ){
				item.onReg( key, this );
				
				items[ key ] = item;
				_count++;				
				
				this.dispatchEvent( new ManagerEvent( ManagerEvent.REG, key, item ) );
			}  
		}
		
		public function unreg(key:String):void
		{
			if ( key == null || key == ""  ){
				return;
			}
			var item : IItem = getItem( key );
			if ( item == null ){
				return;
			}

			item.onUnreg( key, this );
			
			delete items[ key ];
			_count--;
			
			this.dispatchEvent( new ManagerEvent( ManagerEvent.UNREG, key, item ) );
		}
		
		public function getItem(key:String): IItem
		{
			return items[ key ]  ;
		}
		
		public function has(key:String):Boolean
		{
			return getItem( key ) != null;
		}
		
		public function get count():int
		{
			return _count;
		}
		
		public function getAll ()	: Object
		{
			var ret :Object = {};
			
			for( var key:String in items ){
				ret[ key ] = items[ key ];			
			}
			return ret;
		}
		
		public function dismiss():void
		{
			for( var key:String in items ){
				(items[ key ] as IItem).onDismiss( key, this );
			}
			
			this.dispatchEvent( new ManagerEvent( ManagerEvent.DISMISS ) );		
			
			items = new Dictionary();
		}
	}
}