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

		function get speed() : uint;
		
		function get bytesLoaded() : uint;
		
		function get bytesTotal() : uint;
		//--------------------------
		function destroy() : void;
		
		function pause() : void;
		
		function resume() :void;
		
		function load() : void;
		
		function reset() : void;
		
		function close() : void;
		
		//------------------------------------------------
		function isFailed() :Boolean;
		
		function isFinish() :Boolean;
		
		function isLoading() :Boolean;
	}
}