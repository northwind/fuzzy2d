package resource.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import resource.event.ResourceEvent;
	import resource.IResource;
	import resource.IResourceBundle;
	import resource.IResourceManager;
	
	public class ResourceManager extends EventDispatcher implements IResourceManager
	{
		private var _local:String = "cn";
		
		public function ResourceManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function createResource( name:String, url:String = null, callback :Function = null ) :IResource
		{
			if ( name == null || name == ""  ){
				throw new Error( "ResourceManager createResource : name is empty." );
			}
			
			url = url || name;
			//自动替换{local}属性,不支持切换
			url = url.replace( "{local}", _local );
			
			var extension:String = url.replace( /.*[.](\w{1,5})$/i, "$1" );
			
			var ret:IResource;
			
			if ( /jpg|jpeg|gif|png|bmp|ico/i.test( extension )  )
				ret = new ImageResource( name, url );
			
			else if ( /swf/i.test( extension ) )
				ret = new ImageResource( name, url );
				
			else if ( /xml|mxml|xls/i.test( extension ) )
				ret = new ImageResource( name, url );
				
			else if ( /mp3|f4a|f4b/i.test( extension ) )
				ret = new ImageResource( name, url );
				
			else if ( /json/i.test( extension ) )
				ret = new ImageResource( name, url );
				
			else if ( /flv|f4v|f4p|mp4/i.test( extension ) )
				ret = new ImageResource( name, url );
				
			else if ( /txt|js|css|html|php|py|jsp|asp/i.test( extension ) )
				ret = new ImageResource( name, url );
				
			else
				ret = new BaseResource( name, url );
			
			//挂载事件
			if ( callback != null ){
				ret.addEventListener( ResourceEvent.COMPLETE, callback );
			}
			
			return ret;
		}
		
		public function set local(value:String):void
		{
		}
		
		public function addResource(resource:IResource):void
		{
		}
		
		public function removeResource(resource:IResource):void
		{
		}
		
		public function reloadResource(resource:IResource):void
		{
		}
		
		public function pauseResource(resource:IResource):void
		{
		}
		
		public function resumeResource(resource:IResource):void
		{
		}
		
		public function freeResource(resource:IResource):void
		{
		}
		
		public function getResource(name:String):IResource
		{
			return null;
		}
		
		public function addBundle(bundle:IResourceBundle):void
		{
		}
		
		public function removeBundle(bundle:IResourceBundle):void
		{
		}
		
		public function reloadBundle(bundle:IResourceBundle):void
		{
		}
		
		public function pauseBundle(bundle:IResourceBundle):void
		{
		}
		
		public function resumeBundle(bundle:IResourceBundle):void
		{
		}
		
		public function freeBundle(bundle:IResourceBundle):void
		{
		}
		
		public function getBundle(name:String):IResourceBundle
		{
			return null;
		}
		
		public function load():void
		{
		}
		
		public function freeAll():void
		{
		}
		
		public function get failed():Array
		{
			return null;
		}
	}
	
}

/*
package resource.impl
{
public final class ResourceType 
{
	//public static const BASE:uint = 1;
	public static const Image:uint = 2; 
	public static const SWF:uint = 3;
	public static const XML:uint = 4;
	public static const SOUND:uint = 5;
	public static const JSON:uint = 6;
	public static const VIDEO:uint = 7;
	public static const TXT:uint = 8;
	public static const BINARY:uint = 9;
	
	public static function guessType( url: String ) : IResource
	{
		//var pattern:RegExp =/[.](\w{1,5})$/i;
		var extension:String = url.replace( /[.](\w{1,5})$/i, "$1" );
		trace(  "extension = " + extension );
		
		var guess:uint;
		
		if ( /jpg|jpeg|gif|png|bmp|ico/i.test( extension )  )
			guess = ResourceType.Image;
			
		else if ( /swf/i.test( extension ) )
			guess = ResourceType.SWF;
			
		else if ( /xml|mxml|xls/i.test( extension ) )
			guess = ResourceType.XML;
			
		else if ( /mp3|f4a|f4b/i.test( extension ) )
			guess = ResourceType.SOUND;
			
		else if ( /json/i.test( extension ) )
			guess = ResourceType.JSON;
			
		else if ( /flv|f4v|f4p|mp4/i.test( extension ) )
			guess = ResourceType.VIDEO;
			
		else if ( /txt|js|css|html|php|py|jsp|asp/i.test( extension ) )
			guess = ResourceType.TXT;
			
		else
			guess = ResourceType.BINARY;
		
		return guess;
	}
	
} 
}
*/
