package com.norris.fuzzy.core.display
{
	import com.norris.fuzzy.core.cop.IEntity;
	import com.norris.fuzzy.core.manager.IManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 *  屏幕类，对层进行管理
	 *  负责鼠标卷屏操作
	 * @author norris
	 * 
	 */	
	public interface IScreen extends IEntity
	{
		function set name( value:String ) : void;
		
		function get name() : String;
		
		function push( layer:ILayer ) : void ;
		
//		function remove( pri:uint ) : void ;
		
		function get( pri:uint  ) :ILayer;
		
		function get count() : uint;
		
		function get view() : Sprite;
	}
}