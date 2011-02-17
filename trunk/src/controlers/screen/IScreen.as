package controlers.screen
{
	/**
	 * Interface for a screen which can be managed by the ScreenManager.
	 * 
	 * <p>Because we may wish to use DisplayObject subclasses for which we cannot
	 * control the inheritance hierarchy, the ScreenManager requires that screens
	 * be both a DisplayObject and also that they inherit IScreen. BaseScreen is
	 * a simple (and usually sufficient) example of this.</p>
	 */ 	
	public interface IScreen
	{
		function onShow() : void;
		
		function onHide():void;
		
		function onFrame(delta:Number):void;
	}
}