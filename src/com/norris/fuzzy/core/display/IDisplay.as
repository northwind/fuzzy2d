package com.norris.fuzzy.core.display
{
	import flash.events.IEventDispatcher;
	
	[Event(name="show", type="com.norris.fuzzy.core.display.event.DisplayEvent")]
	
	[Event(name="hide", type="com.norris.fuzzy.core.display.event.DisplayEvent")]
	
	[Event(name="destroy", type="com.norris.fuzzy.core.display.event.DisplayEvent")]
	
	/**
	 * 不再使用
	 * 
	 * 显示对象增加show hide 方法
	 * 	
	 * 取消该接口，改为直接继承sprite 不抛出事件
	 * 
	 * @author norris
	 * 
	 */	
	public interface IDisplay extends IEventDispatcher
	{
		function get visible() :Boolean;
		
		function show() : void;
		
		function hide() : void;
		
		function toggle() : void;
		
		function destroy() : void;
	}
}