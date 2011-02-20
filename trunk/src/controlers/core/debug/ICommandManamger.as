package controlers.core.debug
{
	public interface ICommandManamger 
	{
		function registerCommand( name:String, callback:Function, desc :String = "" ) : void;
		
		function excute( line:String ) : void;
		
		function set enable( value:Boolean ) : void; 
	}

}


