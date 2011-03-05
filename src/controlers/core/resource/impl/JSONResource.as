package controlers.core.resource.impl
{
	import com.adobe.serialization.json.JSON;
	
	import controlers.core.resource.IResource;
	
	public class JSONResource extends BaseResource implements IResource
	{
		public function JSONResource(name:String, url:String, policy:*=null)
		{
			super(name, url, policy);
		}
		
		override public function get content():*
		{
			return getJSON();
		}
		
		public function getJSON() : *
		{
			if ( _data == null )
				return null;
			
			var ret : Object ;
			try{
				ret = JSON.decode( _data as String );
			}catch(e  : Error){
//				ret = {}
				ret = null;
			}			
			
			return ret;
		}
	}
}