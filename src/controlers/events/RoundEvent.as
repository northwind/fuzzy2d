package controlers.events
{
	import flash.events.Event;
	
	public class RoundEvent extends Event
	{
		public static const START:String = "round_start";
		public static const END:String = "round_end";
		
		public var No:uint;
		
		public function RoundEvent(type:String,  No:uint )
		{
			super(type, false, false);
			
			this.No = No;
		}
	}
}