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
		
		public var resource:IResource;		//单个resource时有效
		public var speed:Number = 0;		//平均下载速度       kb/s
		public var percent:Number = 0;		//平均下载速度
		public var bytesTotal:uint = 0;		//总下载byte数
		public var bytesLoaded:uint = 0;	//总下载byte数
		public var lastTime:uint = 0;		//总下载时间
		public var ok:Boolean = false;		//是否全部成功
		public var failed:Array = [];			//失败
		public var success :Array = [];			//成功
		
		public function ResourceEvent(type:String, r:IResource = null )
		{
			super(type, false, false );
			
			if ( r != null ){
				this.resource = r;
				
				this.lastTime = r.lastTime;
				this.bytesTotal = r.bytesTotal;
				this.bytesLoaded = r.bytesLoaded;
				this.ok = r.isFinish() && !r.isFailed();
				this.percent = r.bytesLoaded / r.bytesTotal;
				this.speed = (this.bytesLoaded / 1024) / ( this.lastTime / 1000 );
			}
			
		}
	}
}