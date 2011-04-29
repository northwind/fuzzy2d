package controlers.unit
{
	import com.norris.fuzzy.map.astar.Node;
	import controlers.unit.IRange;
	
	/**
	 * 供actionLayer调用的接口 
	 * @author norris
	 * 
	 */	
	public interface IActionable
	{
		function applyTo( node:Node, callback:Function = null ) : void;
		
		function canApply( node:Node ) :Boolean;
		
		function reset() :void;
		
		function get range():IRange;
		
		function showRange():void;
		
		function hideRange():void;
		
		function get active():Boolean; 
	}
}