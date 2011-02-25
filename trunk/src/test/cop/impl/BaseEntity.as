package impl
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	import flash.xml.XMLNode;

	public class BaseEntity implements IEntity
	{
		private var components:Array = [];
		private var needs :Array = [];
		
		public function BaseEntity()
		{
		}
		
		public function addComponent(c:IComponent):void
		{
			components.push( c );
			
			parseComponent( c );
			
		}
		
		private function parseComponent( c:IComponent ) : void
		{
			var xml:XML = describeType( c );
			var variables:XMLList = xml.variable;
			var accessors:XMLList = xml.accessor;
			var belly:Array = [], node :XML, type:String ;

			for each (var variable:XML in variables) {
				type = (variable.@type).toString();
				trace( c[ (variable.@name).toString() ] is IComponent );
				if ( (getDefinitionByName(type) as Class) is IComponent ){
					belly.push( [ (variable.@name).toString(), (variable.@type).toString(), NeedFeed.SINGLE ] );					
				}				
			}
			
//			for( i = 0; i<accessors.length(); i ++ ){
//				node = accessors[ i ] as XML;
//				
//		 		belly.push( [ (node.@name).toString(), (node.@type).toString(), NeedFeed.MULTIPLE ] );
//			}	
			
			//如果有需要注射的属性, 则添加到needs数组中
			if ( belly.length > 0 ){
				var nf:NeedFeed = new NeedFeed( c, belly );
				needs.push( nf );
			}
			
		}
		
		[Deprecated]
		public function setup():void
		{
		}
		
		public function destroy():void
		{
		}
	}
}

internal class NeedFeed {
	
	private var c :IComponent;
	/**
	 *[ [ param, type, multiple ], ... ] 
	 */	
	private var belly:Array = [];
	
	public static const SINGLE : int = 1;
	public static const MULTIPLE : int = 2;
	
	public function NeedFeed( c :IComponent, belly :Array )
	{
		this.c = c;
		this.belly = belly;
	}
	
	public function get isFull() :Boolean
	{
		return belly.length == 0;
	}
	
	public function feed( food:IComponent ) : void 
	{
		for( var i:int = 0; i<belly.length; i ++ ){
			if ( belly[i] == food ){
				c[ belly[i] ] = food;
				belly.splice( i, 1 );
			}
		}		
	}
	
}
