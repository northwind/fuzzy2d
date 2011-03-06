package controlers.core.display
{
	import controlers.core.manager.IStrictManager;

	/**
	 *  显示层 用来叠加显示
	 * @author norris
	 * 
	 */	
	public interface ILayer extends IDisplay
	{
		
		function set pri( value:uint ) :void;
		
		function get pri() :uint;
		
	}
}