package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	import controlers.unit.IRange;
	
	public interface IMoveable extends IComponent
	{
		function moveTo( row:int, col:int ) : void;
		
		function get range():IRange;
		
		function showRange():void;
		
		function hideRange():void;
		
		function canMove( row:int, col:int ) :Boolean;
		
		function get active():Boolean; 
	}
}