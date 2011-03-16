package models.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import models.IDataModel;
	
	public class BaseModel extends EventDispatcher implements IDataModel
	{
		public function BaseModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function loadData():void
		{
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