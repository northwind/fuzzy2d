package models.impl
{
	import models.IDataModel;
	
	import server.*;
	
	public class PlayerModel extends BaseModel implements IDataModel
	{
		public var uid:String;
		
		public function PlayerModel( uid:String )
		{
			super();
			
			this.uid = uid;
		}
		
		override public function loadData():void
		{
			super.loadData();
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Player, { id:this.uid }, null, onResponse ) );
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