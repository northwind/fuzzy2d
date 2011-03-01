package resource.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import resource.IResource;
	
	public class BaseResource extends EventDispatcher implements IResource
	{
		private var _name:String;
		private var _url:String;
		
		public function BaseResource( name:String, url:String = null )
		{
			super( null );
			
			this._name = name;
			this._url = url;
			
			trace( name );
		}
		
		public function get content():*
		{
			return null;
		}
		
		public function set name(value:String):void
		{
		}
		
		public function get name():String
		{
			return null;
		}
		
		public function set url(value:String):void
		{
		}
		
		public function get url():String
		{
			return null;
		}
		
		public function free():void
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
		
		public function speed():uint
		{
			return 0;
		}
		
		public function reload():void
		{
		}
		
		public function isFailed():Boolean
		{
			return false;
		}
	}
}