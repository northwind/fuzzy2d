package controlers.core.cop.impl
{
	import controlers.core.cop.IEntity;
	import controlers.core.cop.IComponent;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLNode;
	
	/**
	 *  
	 * @author norris
	 * 
	 */	
	public class ComponentInfo
	{
		public var component : IComponent;
		/**
		 * [ [ name, type ], ...  ] 
		 */		
		private var _variables:Array = [];
		/**
		 * [ [ name, type ], ...  ] 
		 */	
		private var _accessors:Array = [];
		/**
		 * [ name, name, ...  ] 
		 */	
		private var _interfaces :Array = [];
		private var _done:Boolean = true;
		
		public function ComponentInfo( c:IComponent )
		{
			this.component = c;
			
			parseComponent( c );
		}
		
		private function parseComponent( c:IComponent ) : void
		{
			var xml:XML = describeType( c );
			var variables:XMLList = xml.variable;
			var accessors:XMLList = xml.accessor;
			var interfaces:XMLList = xml.implementsInterface;
			var node :XML, type:String, access:String;
			
			//属性
			for each (var variable:XML in variables) {
				_variables.push( [ (variable.@name).toString(), (variable.@type).toString() ] );					
			}
			
			//读写器
			for each (var accessor:XML in accessors) {
				//只增加可写的访问器
				if ( /write/i.test( (accessor.@access).toString() ) ){
					_accessors.push( [ (accessor.@name).toString(), (accessor.@type).toString() ] );	
				}
			}
			
			//接口
			for each (var interfacer:XML in interfaces) {
				_interfaces.push( (interfacer.@type).toString() );					
			}
			
			_done = _variables.length == 0 && _accessors.length == 0; 
		}
		
		public function hasParameter() : Boolean
		{
			return !_done;
		}
		
		public function injectComponent( inject:ComponentInfo ) : void
		{
			var i :int, variable:Array;
			for( i =_variables.length - 1; i >= 0; i-- ){
				variable = _variables[ i ] as Array;
				
				if ( inject.isInterfaceOf( variable[1] as String ) ){
					this.component[ variable[0] ] = inject.component;
					
					_variables.splice( i, 1 );
					
					//没有直接跳出去
					if ( _variables.length == 0 )
						break;					
				}
			}
			
			var accessor:Array;
			for( i =_accessors.length - 1; i >= 0; i-- ){
				accessor = _accessors[ i ] as Array;
				
				if ( inject.isInterfaceOf( accessor[1] as String ) ){
					this.component[ accessor[0] ] = inject.component;
				}
			}
			
			_done = _variables.length == 0 && _accessors.length == 0; 
		}	
		
		/**
		 * 是否实现了某类接口
		 * @param type
		 * @return 
		 * 
		 */		
		public function isInterfaceOf ( type:String ) : Boolean
		{
			return _interfaces.indexOf( type ) > -1;	
		}
		
	}
}