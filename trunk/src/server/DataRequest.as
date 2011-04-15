package server
{
	/**
	 * 与server端通信的请求类
	 * 包含所需的逻辑数据
	 * 为提高效率，采用Object替代DataRequest
	 * @author norris
	 * 
	 */	
	public class DataRequest
	{
		public static const TYPE_System:uint = 1;			//系统信息（玩家登陆，公告，出错等）
		public static const TYPE_Battle:uint = 2;			//战斗信息
		public static const TYPE_ACK:uint = 3;			//应答信息
		public static const TYPE_Campaign:uint = 4;			//剧情信息（大地图）
		public static const TYPE_Map:uint = 5;			//战场地图（map ini）（包括选择的武将信息）
		public static const TYPE_Record:uint = 6;			//存档信息
		public static const TYPE_Script:uint = 7;			//脚本信息
		
		public static const TYPE_Player:uint = 21;			//玩家信息
		public static const TYPE_Transaction:uint = 22;			//买卖信息
		public static const TYPE_Stuff:uint = 23;			//物品信息
		public static const TYPE_Unit:uint = 24;			//角色信息
		public static const TYPE_Skill:uint = 25;			//技能信息
		public static const TYPE_Figure:uint = 26;			//形象信息
		
		public var t:Number;						//时间戳
		public var cn:uint;							//客户端操作序列号 server类写入
		public var sn:uint;							//服务器端操作序列号
		public var from:String;					//发起者玩家ID
		public var to:String;						//接收者玩家ID
		public var type:uint;						//消息类型
		public var data:Object;					//具体消息内容

//		public var rtype	:uint;						//返回类型
//		public var rvalue:Object;				//返回值

		public var callback:Function;
		
		public function DataRequest()
		{
			t =  (new Date()).getTime();
		}
			
	}
}