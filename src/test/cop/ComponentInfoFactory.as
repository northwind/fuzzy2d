package
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	import controlers.core.cop.impl.ComponentInfo;
	
	/**
	 * 简化接口，不去实现IManager 
	 * @author norris
	 * 
	 */	
	public class ComponentInfoFactory
	{
		private static var items:Dictionary = new Dictionary();
		
		public function ComponentInfoFactory()
		{
		}
		
		public static function createComponentInfo( c:IComponent ):ComponentInfo
		{
			var key:String = getQualifiedClassName( c );
			if ( items[ key ] != null )
				return items[ key ] as ComponentInfo;
			
			//new an instance
			var info : ComponentInfo = new ComponentInfo( c );
			items[ key ] = info;
			
			return info;
		}
		
		public static function destroy() : void
		{
			for( var key:String in items )
				delete items[ key ];
		}
	
	}
}