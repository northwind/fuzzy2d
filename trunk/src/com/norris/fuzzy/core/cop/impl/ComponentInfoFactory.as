package com.norris.fuzzy.core.cop.impl
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.IEntity;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 简化接口，不去实现IManager 
	 * @author norris
	 * 
	 */	
	public class ComponentInfoFactory
	{
		private static var items:Dictionary = new Dictionary();
		
		public static function createComponentInfo( c:IComponent ):ComponentInfo
		{
			var key:String = getQualifiedClassName( c );
			if ( items[ key ] != null ){
				var n:ComponentInfo = ( items[ key ] as ComponentInfo ).clone();
				n.component = c;
				return n;
			}
			//new an instance
			var info : ComponentInfo = new ComponentInfo( c );
			//clone an info
			items[ key ] = info.clone();
			
			return info;
		}
		
		public static function destroy() : void
		{
			for( var key:String in items )
				delete items[ key ];
		}
	
	}
}