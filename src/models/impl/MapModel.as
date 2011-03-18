package models.impl
{
	import flash.events.IEventDispatcher;
	
	import server.*;
	
	public class MapModel extends BaseModel
	{
		public var id:String;
		
		public function MapModel( id:String )
		{
			super();
			
			this.id = id;
		}
		
		override public function loadData():void
		{
			super.loadData();
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Map, { id:this.id }, null, onResponse ) );
		}
		
		private function onResponse( value:* ) :void
		{
			if ( value == null )
				this.onError();
			else
				this.onCompleted( value );
		}
		
		public function getRenders() : Array
		{
			return [ [1,1],[2,1] ];
		}
		
		public function get bgPath() :String
		{
			return "http://slgengine.sinaapp.com/test/battle.png";
		}
		
	}
}