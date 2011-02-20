package controlers.core.screen.impl
{
	import controlers.core.manager.impl.BaseManager;
	import controlers.core.screen.IScreenManager;
	import controlers.core.log.Logger;
	
	public class BaseScreenManager extends BaseManager implements IScreenManager
	{
		public function BaseScreenManager()
		{
			super();
		}
		
		public function goto(name:String):void
		{
			Logger.info( "BaseScreenManager - goto : " + name );
		}
	}
}