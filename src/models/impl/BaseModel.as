package models.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import models.IDataModel;
	import models.event.ModelEvent;
	
	public class BaseModel extends EventDispatcher implements IDataModel
	{
		public function BaseModel()
		{
			super();
		}
		
		public function loadData():void
		{
			this.dispatchEvent( new ModelEvent( ModelEvent.START, this ) );
			
			this.dispatchEvent( new ModelEvent( ModelEvent.COMPLETED, this ) );
		}
		
		public function get data():*
		{
			return null;
		}
		
		public function reloadData():void
		{
		}
	}
}