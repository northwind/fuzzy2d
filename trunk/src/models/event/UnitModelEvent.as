package models.event
{
	import flash.events.Event;
	
	import models.impl.UnitModel;
	
	public class UnitModelEvent extends ModelEvent
	{
		public static var CHANGE_POSITION:String = "change_position";
		
		public var unit:UnitModelEvent;
		
		public function UnitModelEvent( type:String, unit:UnitModelEvent )
		{
			super(type, unit);
			
			this.unit = unit;
		}
	}
}