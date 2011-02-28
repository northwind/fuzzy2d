package resource.event
{
	import flash.events.Event;
	
	public class ResourceEvent extends Event
	{
		public static var COMPLETE:String = "complete";
		
		public function ResourceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}