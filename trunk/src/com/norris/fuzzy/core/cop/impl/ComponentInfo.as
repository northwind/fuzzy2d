package com.norris.fuzzy.core.cop.impl
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.IEntity;
	import com.norris.fuzzy.core.cop.impl.Parameter;
	
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
		
		public var name:String;
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
		
		public function ComponentInfo( c:IComponent = null )
		{
			if ( c != null ){
				this.component = c;
				parseComponent( c );
			}	
		}
		
		private function parseComponent( c:IComponent ) : void
		{
			var xml:XML = describeType( c );
			var variables:XMLList = xml.variable;
			var accessors:XMLList = xml.accessor;
			var interfaces:XMLList = xml.implementsInterface;
			var node :XML, type:String, access:String;
			
			name = xml.@name.toString();
			
			//属性
			for each (var variable:XML in variables) {
				//只存继承了IComponent接口的元素
				type = (variable.@type).toString();				
				if ( Parameter.isExtendIComponent( type ) )
					_variables.push( [ (variable.@name).toString(), type ] );					
			}
			
			//读写器
			for each (var accessor:XML in accessors) {
				//只存继承了IComponent接口的元素
				type = (accessor.@type).toString();		
				//只增加可写的访问器
				if ( /write/i.test( (accessor.@access).toString() ) && Parameter.isExtendIComponent( type ) ){
					_accessors.push( [ (accessor.@name).toString(), type ] );	
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
			return name == type || _interfaces.indexOf( type ) > -1;	
		}
		
		public function clone() :ComponentInfo
		{
			var n:ComponentInfo = new ComponentInfo();
			n.name = this.name;
			n._accessors = this._accessors.slice(0, this._accessors.length ); 
			n._interfaces = this._interfaces.slice(0, this._interfaces.length );
			n._variables = this._variables.slice(0, this._variables.length );
			n._done = n._variables.length == 0 && n._accessors.length == 0; 
			
			return n;
		}
		
	}
}