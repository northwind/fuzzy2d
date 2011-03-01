package resource
{
	import flash.utils.Dictionary;
	
	public class BaseManager
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
			var item : * = get( key );
			if ( item == null ){
				//log
				return;
			}
			
			delete items[ key ];
			_count--;
		}
		
		public function get(key:String): *
		{
			return items[ key ]  ;
		}
		
		public function has(key:String):Boolean
		{
			return get( key ) != null;
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
		}
	}
}