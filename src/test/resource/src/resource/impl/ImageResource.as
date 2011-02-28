package resource.impl
{
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	
	import resource.IResource;
	
	public class ImageResource extends BaseResource
	{
		public function ImageResource( name:String, url:String = null )
		{
			super( name, url );
		}
		
	   override  public function get content(): *
		{
			return null;
		}
		
	}
}