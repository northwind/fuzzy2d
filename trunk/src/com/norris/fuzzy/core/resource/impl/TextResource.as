package com.norris.fuzzy.core.resource.impl
{
	import com.norris.fuzzy.core.resource.IResource;
	import flash.net.URLLoaderDataFormat;
	
	public class TextResource extends BaseResource implements IResource
	{
		public function TextResource(name:String, url:String, policy:*=null)
		{
			super(name, url, policy);
		}
		
		override protected function createLoader() : void
		{
			super.createLoader();
			
			this._loader.dataFormat = URLLoaderDataFormat.TEXT;
		}
		
		override public function get content():*
		{
			return getString();
		}
		
		public function getString() : String
		{
			if ( this._data == null )
				return "";
			
			return this._data as String;
		}
		
	}
}