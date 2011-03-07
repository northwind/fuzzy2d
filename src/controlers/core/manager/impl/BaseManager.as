package controlers.core.manager.impl
{
	import controlers.core.manager.IManager;
	import flash.utils.Dictionary;
	
	public class BaseManager implements IManager
	{
		private var items:Dictionary = new Dictionary();
		private var _count:int = 0;
		
		public function BaseManager()
		{
		}
		
		public function reg(key:String, item: * ):void
		{
			if ( key == "" ){
				//log
				return;
			}
			if ( item == null ){
				//log
				return;
			}
			
			if ( !has( key ) ){
				
				items[ key ] = item;
				_count++;				
				
			}  
		}
		
		public function unreg(key:String):void
		{
			if ( key == "" ){
				//log
				return;
			}
			var item : * = find( key );
			if ( item == null ){
				//log
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
		}
	}
}