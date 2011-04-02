package com.norris.fuzzy.core.cop.impl
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	import flash.events.EventDispatcher;
	
	public class BaseComponent extends EventDispatcher  implements IComponent
	{
		public function BaseComponent()
		{
		}
		
		public function onSetup() : void
		{
			
		}
		
		public function destroy():void
		{
		}
	}
}