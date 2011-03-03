package controlers.core.resource.impl
{
	import controlers.core.resource.IResource;
	import flash.net.URLLoaderDataFormat;
	
	public class BinaryResource extends BaseResource implements IResource
	{
		public function BinaryResource(name:String, url:String, policy:*=null)
		{
			super(name, url, policy);
		}
		
		override protected function createLoader() : void
		{
			super.createLoader();
			
			this._loader.dataFormat = URLLoaderDataFormat.BINARY;
		}
		
	}
}