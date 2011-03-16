package server
{
	/**
	 * 与server端通信的请求类
	 * 包含所需的逻辑数据
	 * @author norris
	 * 
	 */	
	
	public class DataRequest
	{
		public var type:uint;
		public var opponent :String;
		public var data:Object;
		
		public function DataRequest()
		{
		}
			
	}
}