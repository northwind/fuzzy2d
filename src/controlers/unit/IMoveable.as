package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	public class IMoveable implements IComponent
	{
		function moveTo( row:int, col:int ) : void;
		
		function getMoveRange():Array;
		
		function canMove( row:int, col:int ) :Boolean;
	}
}