package controlers.core.debug
{
	import controlers.core.display.IDisplay;

	public interface IConsole extends IDisplay
	{
		function writeLine( content:String ) : void;
		
		function clear() : void;
		
		function getContent() : String;
	}
}