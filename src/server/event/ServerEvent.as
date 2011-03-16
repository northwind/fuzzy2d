package server.event
{
	import flash.events.Event;
	
	import server.IDataServer;
	
	public class ServerEvent extends Event
	{
		public static const Connect:String = "server_connect";
		public static const Disconnect:String = "server_disconnect";
		public static const Error:String = "server_error";
		public static const Receive:String = "server_receive";
		
		public var server:IDataServer;
		
		public function ServerEvent(type:String, server:IDataServer )
		{
			super(type, false, false);
			
			this.server = server;
		}
	}
}