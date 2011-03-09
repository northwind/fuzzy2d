package com.norris.fuzzy.core.manager.impl
{
	import com.norris.fuzzy.core.manager.IItem;
	import com.norris.fuzzy.core.manager.IStrictManager;
	import com.norris.fuzzy.core.manager.events.ManagerEvent;
	import com.norris.fuzzy.core.log.Logger;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 *  不再实现IStrictManager, 所有方法改为protected，只被继承使用 
	 * @author norris
	 * 
	 */	
	public class BaseStrictManager extends EventDispatcher 
	{
		private var items:Dictionary = new Dictionary();
		private var _count:int = 0;
		
		public function BaseStrictManager()
		{
		}
		
		protected function reg(key:String, item:IItem ):void
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
		
		protected function unreg(key:String):void
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
		
		protected function getItem(key:String): IItem
		{
			return items[ key ]  ;
		}
		
		protected function has(key:String):Boolean
		{
			return getItem( key ) != null;
		}
		
		public function get count():int
		{
			return _count;
		}
		
		protected function getAll ()	: Object
		{
			var ret :Object = {};
			
			for( var key:String in items ){
				ret[ key ] = items[ key ];			
			}
			return ret;
		}
		
		protected function dismiss():void
		{
			for( var key:String in items ){
				(items[ key ] as IItem).onDismiss( key, this );
			}
			
			this.dispatchEvent( new ManagerEvent( ManagerEvent.DISMISS ) );		
			
			items = new Dictionary();
		}
	}
}