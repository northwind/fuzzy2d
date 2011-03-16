package models.impl
{
	import flash.events.IEventDispatcher;
	
	public class MapModel extends BaseModel
	{
		public function MapModel()
		{
			super();
		}
		
		public function getRenders() : Array
		{
			return [ [1,1],[2,1] ];
		}
		
		public function get bgPath() :String
		{
			return "http://slgengine.sinaapp.com/test/battle.png";
		}
		
	}
}