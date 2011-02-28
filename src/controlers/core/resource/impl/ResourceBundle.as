package resource.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import resource.IResource;
	import resource.IResourceBundle;
	
	public class ResourceBundle extends EventDispatcher implements IResourceBundle
	{
		public function ResourceBundle(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function set name(value:String):void
		{
		}
		
		public function get name():String
		{
			return null;
		}
		
		public function addResource(resource:IResource):void
		{
		}
		
		public function removeResource(resource:IResource):void
		{
		}
		
		public function reload():void
		{
		}
		
		public function pause():void
		{
		}
		
		public function resume():void
		{
		}
		
		public function load():void
		{
		}
		
		public function freeAll():void
		{
		}
		
		public function get speed():uint
		{
			return 0;
		}
		
		public function get failed():Array
		{
			return null;
		}
		
		public function reloadFailed():void
		{
		}
	}
}