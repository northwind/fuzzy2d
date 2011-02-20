package controlers.screen
{
	import controlers.core.manager.IManager;

	public interface IScreenManager extends IManager
	{
		function goto( name :String ) : void;
	}
}