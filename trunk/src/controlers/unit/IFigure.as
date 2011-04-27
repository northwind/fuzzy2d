package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.astar.Node;
	import com.norris.fuzzy.map.astar.Path;
	
	public interface IFigure extends IComponent
	{
		/**
		 * 返回真正用于显示的mapItem 
		 * @return 
		 * 
		 */		
		function get mapItem () :IMapItem;
		
		function get direct():uint;
		
		function gray() : void;
		
		function highlight() : void;
		
		function faceTo( node:Node ) : void;
		
		function turnTo( direct:uint ):void;
		
		function attackTo( node:Node = null, callback:Function = null ) : void;
	}
}