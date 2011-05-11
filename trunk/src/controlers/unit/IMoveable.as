package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.map.astar.Node;

	/**
	 * 移动功能 
	 * @author norris
	 * 
	 */	
	public interface IMoveable extends IComponent, IActionable
	{
		/**
		 * 不受行动力的限制，不考虑敌友军 
		 * @param to
		 * @param callback
		 * 
		 */		
		function moveTo( to:Node, callback:Function = null ) : void;
	}
}