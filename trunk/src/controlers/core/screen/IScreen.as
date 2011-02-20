package controlers.core.screen
{
	import controlers.core.display.IDisplay;
	import controlers.core.manager.IItem;

	public interface IScreen extends IDisplay, IItem
	{
		function onFrame(delta:Number):void;
	}
}