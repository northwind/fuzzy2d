package resource.event
{
	import flash.events.Event;
	
	import resource.IResource;
	
	public class ResourceEvent extends Event
	{
		public static var COMPLETE:String = "resource_complete";
		public static var PROCESS:String = "resource_process";
		public static var ERROR:String = "resource_error";
		public static var STOP:String = "resource_stop";
		public static var PAUSE:String = "resource_pause";
		public static var RESUME:String = "resource_resume";
		
		public var resource:IResource;		//单个resource时有效
		public var speed:uint = 0;				//平均下载速度
		public var bytesTotal:uint = 0;			//总下载byte数
		public var bytesLoaded:uint = 0;		//总下载byte数
		public var ok:Boolean = false;		//是否全部成功
		public var failed:Array;						//失败
		public var success :Array;				//成功
		
		public function ResourceEvent(type:String, resource )
		{
			super(type, false, false );
			
			this.resource = resource;
		}
	}
}