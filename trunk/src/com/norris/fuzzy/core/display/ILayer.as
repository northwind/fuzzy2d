package com.norris.fuzzy.core.display
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.manager.IStrictManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 *  显示层 用来叠加显示
	 *  TODO 采用DisplayObject 替代 Sprite
	 * @author norris
	 * 
	 */	
	public interface ILayer extends IComponent
	{
//		function set pri( value:uint ) :void;
//		
//		function get pri() :uint;
		
		function get view() :Sprite;
		
//		function set view( value:Sprite ) :void;
	}
}