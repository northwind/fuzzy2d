package controlers.events
{
	import com.norris.fuzzy.map.astar.Node;
	
	import flash.events.Event;
	
	public class TileEvent extends Event
	{
		public static const MOVE:String = "move_tile";
		public static const SELECT:String = "select_tile";
		
		public var row:int;
		public var col:int;
		public var node:Node;
		
		public function TileEvent(type:String, row:int, col:int, node:Node = null )
		{
			super(type, false, false);
			
			this.row = row;
			this.col = col;
			this.node = node;
		}
	}
}