package models
{
	
	/**
	 * 接收model调用，组装请求，调用server 
	 * @author norris
	 * 
	 */	
	public class ProxyServer
	{
		public function ProxyServer()
		{
		}
		
		/**
		 * 设置server 
		 * @param value
		 * 
		 */		
		public function set server( value:IServer ) : void
		{
			
		}
		
		public function createRequest() : DataRequest
		{
			return null;
		}
		
		public function guessType() :uint
		{
			return 0;
		}
		
		public function registerType() : void
		{
			
		}
		
	}
}