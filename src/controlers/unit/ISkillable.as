package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	import models.impl.SkillModel;
	
	public interface ISkillable extends IComponent
	{
		function get model() :SkillModel;
		
		function applyTo( row:int, col:int ) : void;
		
		function getSkillRange():Array;
		
		function canApply( row:int, col:int ) :Boolean;
		
	}
}