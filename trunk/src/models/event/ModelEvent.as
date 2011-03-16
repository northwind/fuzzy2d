package models.event
{
	import flash.events.Event;
	
	import models.IDataModel;
	
	public class ModelEvent extends Event
	{
		public static var START:String = "load_start";
		public static var COMPLETED:String = "load_completed";
		public static var ERROR:String = "load_error";
		
		public var model:IDataModel;
		
		public function ModelEvent(type:String,  model:IDataModel )
		{
			super(type, false, false);
			
			this.model = model;
		}
	}
}