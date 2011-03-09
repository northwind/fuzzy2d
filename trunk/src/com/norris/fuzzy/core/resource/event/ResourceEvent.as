package com.norris.fuzzy.core.resource.event
{
	import com.norris.fuzzy.core.resource.IResource;
	
	import flash.events.Event;
	
	public class ResourceEvent extends Event
	{
		public static var COMPLETE:String = "resource_complete";
		public static var PROCESS:String = "resource_process";
		public static var ERROR:String = "resource_error";
		public static var STOP:String = "resource_stop";
		public static var OPEN:String = "resource_open";
		
		public var resource:IResource;		//单个resource时有效
		public var resources:Array = [];		//单个resource时有效
		public var speed:Number = 0;		//平均下载速度       kb/s
		public var percent:Number = 0;		//平均下载速度
		public var bytesTotal:uint = 0;		//总下载byte数
		public var lastTime:uint = 0;		//总下载时间
		public var ok:Boolean = false;		//是否全部成功
		public var failed:Array = [];			//失败
		public var success :Array = [];			//成功

		private var _bytesLoaded:uint = 0;	  //总下载byte数   set该属性会自动计算speed和percent
		
		public function ResourceEvent(type:String, r:IResource = null )
		{
			super(type, false, false );
			
			if ( r != null ){
				this.resource = r;
				
				this.lastTime = r.lastTime;
				this.bytesTotal = r.bytesTotal;
				this.bytesLoaded = r.bytesLoaded;
				if ( r.isFinish() ){
					if ( !r.isFailed() ){
						this.ok = true;
						this.success.push( r );
					}else{
						this.ok = false;
//						this.percent = 1;
						this.failed.push( r );
					}
				}
			}
		}
		
		public function set bytesLoaded( value:uint ) : void
		{
			this._bytesLoaded = value;
			
			if ( this.bytesTotal == 0 )
				this.percent = 0;
			else
				this.percent = value / this.bytesTotal;
			
			if ( this.lastTime == 0 )
				this.speed = 0;
			else
				this.speed = ( value / 1024) / ( this.lastTime / 1000 );
		}
		
		public function get bytesLoaded() :uint
		{
			return this._bytesLoaded;
		}
		
	}
}