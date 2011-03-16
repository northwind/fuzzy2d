package com.norris.fuzzy.core.manager.impl
{
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.manager.IManager;
	
	import flash.utils.Dictionary;
	
	/**
	 *  不再实现IManager, 所有方法改为protected，只被继承使用 
	 * @author norris
	 * 
	 */	
	public class BaseManager implements IManager
	{
		private var items:Dictionary = new Dictionary();
		private var _count:int = 0;
		
		public function BaseManager()
		{
		}
		
		public function reg(key:String, item: * ):void
		{
			if ( key == null || key == "" ){
				return;
			}
			if ( item == null ){
				Logger.warning( "BaseManager reg " + key + " : item is null." );
				return;
			}
			
			if ( !has( key ) ){
				
				items[ key ] = item;
				_count++;				
				
			}  
		}
		
		public function unreg(key:String):void
		{
			if ( key == null || key == "" ){
				return;
			}
			var item : * = find( key );
			if ( item == null ){
				return;
			}
			
			delete items[ key ];
			_count--;
		}
		
		public function find(key:String): *
		{
			return items[ key ]  ;
		}
		
		public function has(key:String):Boolean
		{
			return find( key ) != null;
		}
		
		public function get count():int
		{
			return _count;
		}
		
		public function getAll ()	: Object
		{
//			var ret :Object = {};
//			
//			for( var key:String in items ){
//				ret[ key ] = items[ key ];			
//			}
//			return ret;
			return items;
		}
		
		public function dismiss():void
		{
			items = new Dictionary();
		}
	}
}