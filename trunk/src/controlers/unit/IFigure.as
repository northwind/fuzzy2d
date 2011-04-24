package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.astar.Path;
	
	public interface IFigure extends IComponent
	{
		/**
		 * 返回真正用于显示的mapItem 
		 * @return 
		 * 
		 */		
		function get mapItem () :IMapItem;
		
		function walkPath( path:Path, callback:Function = null ) :  void;
		
		function standby() : void;
		
		function highlight() : void;
	}
}