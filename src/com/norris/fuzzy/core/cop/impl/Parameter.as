package com.norris.fuzzy.core.cop.impl
{
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLNode;
	
	public class Parameter
	{
		private static var _extends:Dictionary = new Dictionary();
		private static var _notextends:Dictionary = new Dictionary();
		
		public function Parameter()
		{
		}
		
		
		public static function isExtendIComponent( type:String ):Boolean
		{
			if ( type == null || type == "" )
				return false;
			
			//已存在 继承
			if ( _extends[ type ] == true )
				return true;
			
			//已存在 不是继承
			if ( _notextends[ type ] == true )
				return false;
			
			try{
				
				var obj:Object = getDefinitionByName( type );
				var xml:XML = describeType( obj );
				
			}catch( e:Error){
				_notextends[ type ] = true;
				return false;
			}
			
			//没有继承
			//TODO 优化,采用其他方式替代字符串检索
			var s:String = xml..implementsInterface.toXMLString();
			if ( s.indexOf( "cop::IComponent" ) > -1 ){
				_extends[ type ] == true;
				return true;
			}else{
				_notextends[ type ] = true;
				return false;				
			}
		}
		
	}
}