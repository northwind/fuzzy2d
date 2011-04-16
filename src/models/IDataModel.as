package models
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 开始加载 
	 */	
	[Event(name="start", type="models.event.ModelEvent")]
	
	/**
	 * 成功加载
	 */	
	[Event(name="completed", type="models.event.ModelEvent")]
	
	/**
	 * 加载失败 
	 */	
	[Event(name="error", type="models.event.ModelEvent")]
	
	/**
	 *  数据接口
	 *  调用与接收 
	 * @author norris
	 * 
	 */	
	public interface IDataModel extends IEventDispatcher
	{
		function loadData () : void;
		
		function get data() : *;
	}
}