package models
{
	import flash.events.IEventDispatcher;
	
	[Event(name="destroy", type="com.norris.fuzzy.core.display.event.DisplayEvent")]
	
	/**
	 *  数据接口
	 *  调用与接收 
	 * @author norris
	 * 
	 */	
	public interface IDataModel extends IEventDispatcher
	{
		function loadData ( id:String ) : void;
	}
}