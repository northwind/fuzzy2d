package com.norris.fuzzy.core.debug
{
	import com.norris.fuzzy.core.display.IDisplay;

	[Event(name="destroy", type="com.norris.fuzzy.core.display.event.DisplayEvent")]
	
	public interface IConsole extends IDisplay
	{
		function writeLine( content:String,  color:uint = 0xffffff  ) : void;
		
		function clear() : void;
		
		function getContent() : String;
		
		function onEnter( callback:Function ) : void;
	}
}