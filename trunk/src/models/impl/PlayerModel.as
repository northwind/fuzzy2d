package models.impl
{
	import models.IDataModel;
	
	import server.*;
	
	public class PlayerModel extends BaseModel implements IDataModel
	{
		public var id:String = "";
		
		public function PlayerModel( id:String )
		{
			super();
			
			this.id = id;
		}
		
		override public function loadData():void
		{
			super.loadData();
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Player, { id:this.id }, null, onResponse ) );
		}
		
		private function onResponse( value:* ) :void
		{
			if ( value == null )
				this.onError();
			else
				this.onCompleted( value );
		}
		
		public function get screen() : String
		{
			if ( this.data == null )
				return "";
			
			return this.data[ "screen" ];
		}
		
		public function get money() :uint
		{
			if ( this.data == null )
				return 0;
			
			return this.data[ "money" ];
		}
		
	}
}