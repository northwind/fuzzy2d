package server
{
	import flash.events.IEventDispatcher;

	[Event(name="connect", type="server.event.ServerEvent")]
	
	[Event(name="disconnect", type="server.event.ServerEvent")]
	
	[Event(name="error", type="server.event.ServerEvent")]
	
	[Event(name="receive", type="server.event.ServerEvent")]
	
	/**
	 * 组装成server端可理解的格式，完成与server的通信 
	 * @author norris
	 * 
	 */	
	public interface IDataServer extends IEventDispatcher
	{
		/**
		 * 配置 
		 * @param host
		 * @param port
		 * @param wait  等待多长时间ms发送一次
		 * 
		 */		
		function config( host:String, port:uint, wait:uint = 50, timeout :uint = 10000 ) :void;
		
		function connect() : void;
		
		function close() : void;
		/**
		 * 立即发送 
		 */		
		function send() : void;
		
		function add( request:Object ) : void;

		//不能删除
//		function remove( request:Object ) : void;
	}
}