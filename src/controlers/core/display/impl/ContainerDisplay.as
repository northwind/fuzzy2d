package controlers.core.display.impl
{
	import controlers.core.display.IDisplay;
	import flash.utils.Dictionary;
	
	public class ContainerDisplay extends BaseDisplay
	{
		private var items:Dictionary = new Dictionary();
		private var _count:int = 0;
		
		public function ContainerDisplay(  )
		{
			super();
		}
		
		protected function reg(key:String, item: IDisplay ):void
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
		
		protected function unreg(key:String):void
		{
			if ( key == "" ){
				//log
				return;
			}
			var item : * = getItem( key );
			if ( item == null ){
				//log
				return;
			}
			
			delete items[ key ];
			_count--;
		}
		
		protected function getItem(key:String): IDisplay
		{
			return items[ key ]  ;
		}
		
		protected function has(key:String):Boolean
		{
			return getItem( key ) != null;
		}
		
		protected function get count():int
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
	}
}