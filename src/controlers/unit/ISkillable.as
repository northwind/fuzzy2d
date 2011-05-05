package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	import models.impl.SkillModel;
	
	public interface ISkillable extends IComponent, IActionable
	{
		function get skillModel():SkillModel;
	}
}