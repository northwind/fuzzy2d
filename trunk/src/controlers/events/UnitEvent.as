package controlers.events
{
	import controlers.unit.Unit;
	
	import flash.events.Event;
	
	public class UnitEvent extends Event
	{
		public static const MOVE:String = "unit_move";
		public static const MOVE_OVER:String = "unit_move_over";
		
		public var unit:Unit;
		
		public function UnitEvent(type:String, unit:Unit )
		{
			super(type, false, false );
			
			this.unit = unit;
		}
	}
}