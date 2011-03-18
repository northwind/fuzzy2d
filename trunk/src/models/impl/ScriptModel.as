package models.impl
{
	import models.IDataModel;
	import server.*;
	
	public class ScriptModel extends BaseModel implements IDataModel
	{
		public var id:String;
		
		public function ScriptModel( id:String )
		{
			super();
			
			this.id = id;
		}
		
		override public function loadData():void
		{
			super.loadData();
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Script, { id:this.id }, null, onResponse ) );
		}
		
		private function onResponse( value:* ) :void
		{
			if ( value == null )
				this.onError();
			else
				this.onCompleted( value );
		}
		
	}
}