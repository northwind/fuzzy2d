package models.event
{
	import flash.events.Event;
	
	public class DataEvent extends Event
	{
		public static var START:String = "load_start";
		public static var COMPLETED:String = "load_completed";
		public static var ERROR:String = "load_error";
		
		public function DataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}