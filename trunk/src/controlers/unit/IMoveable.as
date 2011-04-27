package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.map.astar.Node;
	
	import controlers.unit.IRange;
	
	public interface IMoveable extends IComponent
	{
		function moveTo( node:Node, callback:Function = null ) : void;
		
		function reset() :void;
		
		function get range():IRange;
		
		function showRange():void;
		
		function hideRange():void;
		
		function canMove( node:Node ) :Boolean;
		
		function get active():Boolean; 
	}
}