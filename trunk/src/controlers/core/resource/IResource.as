package resource
{
	import flash.events.IEventDispatcher;
	
	public interface IResource extends IEventDispatcher
	{
		function get content () : *;
		
		function set name( value:String ) : void;
		
		function get name() : String;
		
		function set url( value:String ) : void;
		
		function get url() : String; 
		
		//--------------------------
		function free() : void;
		
		function pause() : void;
		
		function resume() :void;
		
		function load() : void;
		
		function speed() : uint;
		
		function reload() : void;
		
		function isFailed() :Boolean;
		
	}
}