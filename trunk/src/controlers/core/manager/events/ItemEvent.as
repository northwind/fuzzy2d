package controlers.core.manager.events
{
	import flash.events.Event;
	
	public class ItemEvent extends Event
	{
		public function ItemEvent(type:String)
		{
			super(type, false, false);
		}
	}
}