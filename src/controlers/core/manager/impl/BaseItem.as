package controlers.core.manager.impl
{
	import controlers.core.manager.IItem;
	import controlers.core.manager.IManager;
	
	public class BaseItem implements IItem
	{
		public function BaseItem()
		{
		}
		
		public function onReg(key:String, manager:IManager):void
		{
		}
		
		public function onUnreg(key:String, manager:IManager):void
		{
		}
		
		public function onDismiss(key:String, manager:IManager):void
		{
		}
	}
}