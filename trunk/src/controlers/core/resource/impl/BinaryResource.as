package controlers.core.resource.impl
{
	import controlers.core.resource.IResource;
	
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	
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
		
		override public function get content():*
		{
			return getByteArray();
		}
		
		/**
		 * 封装 ByteArray.readUTF , 使用readUTFBytes函数读取有效数据
		 * @return 
		 * 
		 */		
		public function readUTF() : String
		{
			var b:ByteArray = this._data as ByteArray;
			if ( b == null )
				return "";
				
			var ret:String;
			
			try{
				ret = b.readUTFBytes( b.bytesAvailable );
			}catch( e:Error){
				ret = "";
			}
			
			return ret;
		}
		
		public function getByteArray() : ByteArray
		{
			if ( this._data == null )
				return null;
			
			return this._data as ByteArray;
		}
		
	}
}