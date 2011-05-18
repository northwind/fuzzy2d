package models.event
{
	import flash.events.Event;
	
	import models.impl.UnitModel;
	
	public class UnitModelEvent extends ModelEvent
	{
		public static var CHANGE_POSITION:String = "change_position";
		public static var CHANGE_HP:String = "change_hp";
		
		public var unit:UnitModel;
		public var offset:Number;
		
		public function UnitModelEvent( type:String, unit:UnitModel )
		{
			super(type, unit);
			
			this.unit = unit;
		}
	}
}