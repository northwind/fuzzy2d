package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	public interface IMoveable extends IComponent
	{
		function moveTo( row:int, col:int ) : void;
		
		function getMoveRange():Array;
		
		function showMoveRange():void;
		
		function hideMoveRange():void;
		
		function canMove( row:int, col:int ) :Boolean;
		
		function get active():Boolean; 
	}
}