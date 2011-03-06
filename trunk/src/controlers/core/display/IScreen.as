package controlers.core.display
{
	import controlers.core.manager.IManager;

	/**
	 *  屏幕类，对层进行管理
	 *  负责鼠标卷屏操作
	 * @author norris
	 * 
	 */	
	public interface IScreen extends IDisplay
	{
		function set name( value:String ) : void;
		
		function get name() : String;
		
		function insert( layer:ILayer ) : void ;
		
		function remove( pri:uint ) : void ;
		
		function get( pri:uint  ) :ILayer;
	}
}