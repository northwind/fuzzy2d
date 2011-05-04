package controlers.events
{
	import controlers.unit.Unit;
	
	import flash.events.Event;
	
	public class UnitEvent extends Event
	{
		public static const MOVE:String = "unit_move";
		public static const MOVE_OVER:String = "unit_move_over";
		public static const STANDBY:String = "unit_standby";
		public static const DEAD:String = "unit_dead";
		public static const START:String = "unit_start";
		public static const SPEAK:String = "unit_start";
		public static const APPEAR:String = "unit_start";
		
		public var unit:Unit;
		
		public function UnitEvent(type:String, unit:Unit )
		{
			super(type, false, false );
			
			this.unit = unit;
		}
	}
}