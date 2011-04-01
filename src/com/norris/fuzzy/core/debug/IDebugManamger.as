package com.norris.fuzzy.core.debug
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	public interface IDebugManamger extends IComponent
	{
		function registerCommand( name:String, callback:Function, desc :String = "" ) : void;
		
		function unregisterCommand( name:String ) : void;
		
		function excute( line:String ) : void;
		
		function toggle() : void;
		
		function set enable( value:Boolean ) : void; 
	}

}


