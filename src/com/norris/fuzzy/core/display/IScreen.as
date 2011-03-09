package com.norris.fuzzy.core.display
{
	import com.norris.fuzzy.core.manager.IManager;

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
		
		function push( layer:ILayer ) : void ;
		
		function remove( pri:uint ) : void ;
		
		function get( pri:uint  ) :ILayer;
	}
}