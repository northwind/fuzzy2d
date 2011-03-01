package resource.event
{
	import flash.events.Event;
	
	import resource.IResource;
	
	public class ResourceEvent extends Event
	{
		public static var COMPLETE:String = "resource_complete";
		public static var PROCESS:String = "resource_process";
		
		public var resource:IResource;
		
		public function ResourceEvent(type:String, resource )
		{
			super(type, false, false );
			
			this.resource = resource;
		}
	}
}