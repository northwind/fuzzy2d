package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.map.IMapItem;
	
	public interface IFigure extends IComponent
	{
		/**
		 * 返回真正用于显示的mapItem 
		 * @return 
		 * 
		 */		
		function get mapItem () :IMapItem;
		
		function walkTo( row:int, col:int ) : void ;
		
		
	}
}