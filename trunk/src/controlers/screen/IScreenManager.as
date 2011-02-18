package controlers.screen
{
	import controlers.manager.IManager;

	public interface IScreenManager extends IManager
	{
		function goto( name :String ) : void;
	}
}