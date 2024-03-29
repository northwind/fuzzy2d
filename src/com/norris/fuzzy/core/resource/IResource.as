package com.norris.fuzzy.core.resource
{
	import flash.events.IEventDispatcher;

	[Event(name="complete", type="resource.event.ResourceEvent")]
	
	[Event(name="process", type="resource.event.ResourceEvent")]
	
	[Event(name="error", type="resource.event.ResourceEvent")]
	
	[Event(name="stop", type="resource.event.ResourceEvent")]
	
	public interface IResource extends IEventDispatcher
	{
		function get content () : *;
		
		function set name( value:String ) : void;
		
		function get name() : String;
		
		function set url( value:String ) : void;
		
		function get url() : String; 

		function get lastTime() : uint;
		
		function get bytesLoaded() : uint;
		
		function get bytesTotal() : uint;
		//--------------------------
		function destroy() : void;
		
		function load() : void;
		
		function reset() : void;
		
		function close() : void;
		
		//------------------------------------------------
		function isFailed() :Boolean;
		
		function isFinish() :Boolean;
		
		function isLoading() :Boolean;
	}
}