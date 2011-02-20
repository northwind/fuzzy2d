package controlers.screen.impl
{
	import controlers.core.manager.impl.BaseManager;
	import controlers.screen.IScreenManager;
	
	public class BaseScreenManager extends BaseManager implements IScreenManager
	{
		public function BaseScreenManager()
		{
			super();
		}
		
		public function goto(name:String):void
		{
			trace ( "goto : " + name );
		}
	}
}