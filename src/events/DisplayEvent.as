package events
{
	import flash.events.Event;
	
	public class DisplayEvent extends Event
	{
		public static const SHOW:String = "show";
		public static const HIDE:String = "hide";
		public static const DESTROY:String = "destroy";
		
		public function DisplayEvent(type:String )
		{
			//TODO: implement function
			super(type, true, false);
		}
	}
}