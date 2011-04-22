package com.norris.fuzzy.core.cop.impl
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="complete", type="flash.events.Event")]
	
	public class BaseComponent extends EventDispatcher  implements IComponent
	{
		public function BaseComponent()
		{
		}
		
		public function onSetup() : void
		{
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function destroy():void
		{
		}
	}
}