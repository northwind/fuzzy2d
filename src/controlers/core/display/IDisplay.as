package controlers.core.display
{
	[Event(name="show", type="events.DisplayEvent")]
	
	[Event(name="hide", type="events.DisplayEvent")]
	
	[Event(name="destroy", type="events.DisplayEvent")]
	
	/**
	 * 显示对象增加show hide 方法
	 * 
	 * @author norris
	 * 
	 */	
	public interface IDisplay 
	{
		function show() : void;
		
		function hide() : void;
		
		function toggle() : void;
		
		function destroy() : void;
	}
}