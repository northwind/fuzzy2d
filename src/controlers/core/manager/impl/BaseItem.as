package controlers.core.manager.impl
{
	import controlers.core.manager.IItem;
	import controlers.core.manager.IStrictManager;
	
	public class BaseItem implements IItem
	{
		public function BaseItem()
		{
		}
		
		public function onReg(key:String, manager:IStrictManager):void
		{
		}
		
		public function onUnreg(key:String, manager:IStrictManager):void
		{
		}
		
		public function onDismiss(key:String, manager:IStrictManager):void
		{
		}
	}
}