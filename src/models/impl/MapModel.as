package models.impl
{
	import flash.events.IEventDispatcher;
	
	public class MapModel extends BaseModel
	{
		public function MapModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function getRenders() : Array
		{
			return [ [1,1],[2,1] ];
		}
		
	}
}