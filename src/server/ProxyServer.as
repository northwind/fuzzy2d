package server
{
	import com.norris.fuzzy.core.log.Logger;
	
	import server.*;
	
	/**
	 * 接收model调用，组装请求，调用server 
	 * @author norris
	 */	
	public class ProxyServer
	{
		public function ProxyServer()
		{
		}

		private static var _server:IDataServer;
		/**
		 *  玩家id 
		 */		
		public static var master:String = "";		
		/**
		 * 设置server 
		 * @param value
		 * 
		 */		
		public static function set server( value:IDataServer ) : void
		{
			_server = value;
		}
		
		public static function createRequest( type:uint, data:Object = null, to:String = null, callback:Function = null ) : Object
		{
			var req:Object = new Object();
			
			req.from =  ProxyServer.master;
			req.type = type;
			req.data = data;
			req.to = to;
			req.callback = callback;
			
			return req;
		}
		
		public static function send( request:Object ) :void
		{
			if ( _server == null ){
				Logger.warning( "ProxyServer sever is null, can't send." );
				return;
			}
			if ( request == null ){
				Logger.warning( "ProxyServer request is null, can't send." );
				return;
			}
			
			_server.add( request );
		}
		
		public static function guessType() :uint
		{
			return 0;
		}
		
		public static function registerType() : void
		{
			
		}
		
	}
}