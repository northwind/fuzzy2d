package controlers.unit
{
	import com.norris.fuzzy.map.astar.Node;

	public interface IRange
	{
		function reset() :void;
		
		function measure() :void;
	
		function get nodes() :Object;
		
		function contains( node:Node ):Boolean;
	}
}