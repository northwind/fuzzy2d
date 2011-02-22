package controlers.core.debug
{
	import controlers.core.display.IDisplay;

	[Event(name="destroy", type="events.DisplayEvent")]
	
	public interface IConsole extends IDisplay
	{
		function writeLine( content:String,  color:uint = 0xffffff  ) : void;
		
		function clear() : void;
		
		function getContent() : String;
		
		function onEnter( callback:Function ) : void;
	}
}