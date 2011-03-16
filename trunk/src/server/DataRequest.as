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
		public var t:Number;						//时间戳
		public var cn:uint;							//客户端操作序列号 server类写入
		public var from:String;					//发起者玩家ID
		public var to:String;						//接收者玩家ID
		public var type:uint;						//消息类型
		public var data:Object;					//具体消息内容

//		public var sn:uint;							//服务器端操作序列号
//		public var rtype	:uint;						//返回类型
//		public var rvalue:Object;				//返回值
		
		public function DataRequest()
		{
			t =  (new Date()).getTime();
		}
			
	}
}