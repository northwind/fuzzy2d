package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	import models.impl.StuffModel;
	
	public interface IStuffable extends IComponent
	{
		function get model() :StuffModel;
		
		function applyTo( row:int, col:int ) : void;
		
		function getRange():Array;
		
		function canApply( row:int, col:int ) :Boolean;
		
	}
}