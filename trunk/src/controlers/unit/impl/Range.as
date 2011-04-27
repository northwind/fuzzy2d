package controlers.unit.impl
{
	import com.norris.fuzzy.map.astar.Node;
	
	import controlers.layers.StaticLayer;
	import controlers.layers.TileLayer;
	import controlers.layers.UnitsLayer;
	import controlers.unit.IRange;
	import controlers.unit.Unit;

	public class Range implements IRange
	{
		public static var tileLayer:TileLayer;
		public static var unitsLayer:UnitsLayer;
		public static var staticLayer:StaticLayer;
		
		public var unit:Unit;
		public var len:uint;
		public var type:int;
		protected var row:int;
		protected var col:int;
		protected var _nodes:Object;
		
		private var dirty:Boolean = true;		//是否需要重新计算
		
		public function Range( unit:Unit, len:uint, type:int )
		{
			this.unit = unit;
			this.len = len;
			this.type = type;
		}
		
		public function get nodes():Object
		{
			return _nodes;
		}
		
		public function reset() : void
		{
			_nodes = {};
			dirty = true;
		}
		
		public function measure() : void
		{
			if ( !dirty )
				return;
			
			dirty = false;
			row = unit.model.row;
			col = unit.model.col;
			_nodes = {};
			
			onMeasure();
		}
		
		protected function addNode( node:Node ) : void
		{
			if ( node != null )
				_nodes[ node.id ] = node;
		}
		
		public function contains( node:Node ):Boolean
		{
			if ( node == null )
				return false;
			
			return _nodes[ node.id ] != undefined;
		}
		
		protected function onMeasure() : void
		{
		}
	}
}