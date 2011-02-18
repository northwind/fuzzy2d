package controlers.screen
{
	import controlers.display.IDisplay;
	import controlers.manager.IItem;

	public interface IScreen extends IDisplay, IItem
	{
		function onFrame(delta:Number):void;
	}
}