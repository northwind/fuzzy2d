package controlers.events
{
	import flash.events.Event;
	
	public class TileEvent extends Event
	{
		public static const MOVE:String = "move_tile";
		public static const SELECT:String = "select_tile";
		
		public var row:int;
		public var col:int;
		
		public function TileEvent(type:String, row:int, col:int )
		{
			super(type, false, false);
			
			this.row = row;
			this.col = col;
		}
	}
}