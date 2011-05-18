package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	import models.impl.StuffModel;
	
	public interface IStuffable extends IComponent, IActionable
	{
		function get stuffModel():StuffModel;
	}
}