package controlers.core.debug
{
	import flash.display.Sprite;
	
	public interface IDebugManamger 
	{
		function init( container:Sprite ) : void;
		
		function registerCommand( name:String, callback:Function, desc :String = "" ) : void;
		
		function excute( line:String ) : void;
		
		function toggle() : void;
		
		function set enable( value:Boolean ) : void; 
	}

}


