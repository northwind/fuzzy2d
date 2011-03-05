package controlers.core.resource.impl
{
	import controlers.core.resource.IResource;
	
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	
	public class URLVariablesResource extends BaseResource implements IResource
	{
		public function URLVariablesResource(name:String, url:String, policy:*=null)
		{
			super(name, url, policy);
		}
		
		override protected function createLoader() : void
		{
			super.createLoader();
			
			this._loader.dataFormat = URLLoaderDataFormat.VARIABLES;
		}
		
		override public function get content():*
		{
			return getURLVars();
		}
		
		public function getURLVars() : URLVariables
		{
			if ( this._data == null )
				return null;
			
			return this._data as URLVariables;
		}		
		
		public function getString() : String
		{
			if ( this._data == null )
				return "";
			
			return ( this._data as URLVariables ).toString();
		}
		
	}
}