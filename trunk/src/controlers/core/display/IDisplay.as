package controlers.core.display
{
	import flash.events.IEventDispatcher;
	
	[Event(name="show", type="events.DisplayEvent")]
	
	[Event(name="hide", type="events.DisplayEvent")]
	
	[Event(name="destroy", type="events.DisplayEvent")]
	
	/**
	 * 显示对象增加show hide 方法
	 * 	
	 * 取消该接口，改为直接继承sprite 不抛出事件
	 * 
	 * @author norris
	 * 
	 */	
	public interface IDisplay extends IEventDispatcher
	{
		function show() : void;
		
		function hide() : void;
		
		function toggle() : void;
		
		function destroy() : void;
	}
}