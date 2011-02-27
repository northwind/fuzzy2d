package controlers.core.screen.impl
{
	import controlers.core.manager.impl.BaseStrictManager;
	import controlers.core.screen.IScreenManager;
	import controlers.core.log.Logger;
	
	public class BaseScreenManager extends BaseStrictManager implements IScreenManager
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