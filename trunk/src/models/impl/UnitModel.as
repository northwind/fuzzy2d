package models.impl
{
	import models.IDataModel;
	import server.*;
	
	public class UnitModel extends BaseModel implements IDataModel
	{
		public var id:String;
		
		public function UnitModel( id:String, attr:Object = null )
		{
			super();
			
			this.id = id;
			//设置属性
			if ( attr != null ){
				
			}
		}
		
		override public function loadData():void
		{
			super.loadData();
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Unit, { id:this.id }, null, onResponse ) );
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