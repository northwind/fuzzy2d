package com.norris.fuzzy.core.manager.impl
{
	import com.norris.fuzzy.core.manager.IItem;
	import com.norris.fuzzy.core.manager.IStrictManager;
	
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