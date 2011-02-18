package controlers.manager.events
{
	import flash.events.Event;
	
	public class ManagerEvent extends Event
	{
		public static const REG:String = "reg";
		public static const UNREG:String = "unreg";
		public static const DISMISS:String = "dismiss";
		
		public var key :String;
		public var item : *;
		
		public function ManagerEvent(type:String, key :String = "", item : * = null )
		{
			this.key = key;
			this.item = item;
			
			super(type, false, false );
		}
	}
}