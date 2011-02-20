package controlers.core.screen.impl
{
	import controlers.core.manager.impl.BaseManager;
	import controlers.core.screen.IScreenManager;
	import controlers.core.log.Logger;
	
	public class BaseScreenManager extends BaseManager implements IScreenManager
	{
		[Inject]
		public var logger:Logger;
		
		public function BaseScreenManager()
		{
			super();
		}
		
		public function goto(name:String):void
		{
			logger.info( "BaseScreenManager - goto : " + name );
		}
	}
}