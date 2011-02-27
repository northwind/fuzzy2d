package controlers.core.screen
{
	import controlers.core.manager.IStrictManager;

	public interface IScreenManager extends IStrictManager
	{
		function goto( name :String ) : void;
	}
}