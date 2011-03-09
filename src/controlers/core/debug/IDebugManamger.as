package controlers.core.debug
{
	import controlers.core.cop.IComponent;
	
	import flash.display.Sprite;
	
	public interface IDebugManamger extends IComponent
	{
		function registerCommand( name:String, callback:Function, desc :String = "" ) : void;
		
		function excute( line:String ) : void;
		
		function toggle() : void;
		
		function set enable( value:Boolean ) : void; 
	}

}


