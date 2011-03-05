package controlers.core.resource.impl
{
	import controlers.core.resource.IResource;
	
	public class XMLResource extends BaseResource implements IResource
	{
		public function XMLResource(name:String, url:String, policy:*=null)
		{
			super(name, url, policy);
		}
		
		override public function get content():*
		{
			return getXML();
		}
		
		public function getXML() :XML
		{
			if ( _data == null )
				return null;
			
			var ret : XML ;
			try{
				ret = new XML( _data );
			}catch(e  : Error){
//				ret = new XML();
				ret = null;
			}	
			
			return ret;
		}
	}
}