package models.impl
{
	import models.IDataModel;
	import models.event.ModelEvent;
	
	import server.*;
	
	public class RecordModel extends BaseModel implements IDataModel
	{
		public var id:String = "";
		
		private var _map:MapModel;
		private var _script:ScriptModel;
		private var _units:Object;
		
		private var _relates:uint;
		private var _downloads:uint;
		
		public function RecordModel( id:String )
		{
			super();
			
			this.id = id;
		}
		
		override public function loadData():void
		{
			super.loadData();
			
			ProxyServer.send( ProxyServer.createRequest( DataRequest.TYPE_Record, { id:this.id }, null, onResponse ) );
		}
		
		private function onResponse( value:* ) :void
		{
			if ( value == null )
				this.onError();
			else{
				this._data = value;
				var units:Array = value["units"] as Array;
				if ( units == null ){
					this.onError();
					return;
				}
				
				this._relates = 2 + units.length;			//需要下载的资源数
				this._downloads = 0;
				this._units = {};
				
				//继续下载地图信息和脚本信息和角色信息
				//TODO 考虑已下载的情况
				_map = new MapModel( value["mapID"] );
				_map.addEventListener( ModelEvent.COMPLETED, onRelatedCompleted );
				_map.addEventListener( ModelEvent.ERROR, onRelatedError );
				_map.loadData();
				//读取脚本
				_script = new ScriptModel( value["scriptID"] );
				_script.addEventListener( ModelEvent.COMPLETED, onRelatedCompleted );
				_script.addEventListener( ModelEvent.ERROR, onRelatedError );
				_script.loadData();
				
				//读取角色信息
				var u:UnitModel, id:String;
				for( var i:uint=0; i <units.length; i++ ){
					id = units[i]["id"];
					u = new UnitModel( id , units[i] );
					u.addEventListener( ModelEvent.COMPLETED, onRelatedCompleted );
					u.addEventListener( ModelEvent.ERROR, onRelatedError );
					u.loadData();
					
					_units[ id ] = u;
				}
			}
		}
		
		private function onRelatedCompleted( event:ModelEvent = null ) :void
		{
			//clear listner 防止相关model再次读取数据时调用次接口
			event.model.removeEventListener( ModelEvent.COMPLETED, onRelatedCompleted );
			event.model.removeEventListener( ModelEvent.ERROR, onRelatedError );
			
			if ( ++this._downloads == this._relates ){
				//TODO处理已触发过的事件
				
				this.onCompleted( this._data );
			}
		}
		
		private function onRelatedError( event:ModelEvent ) :void
		{
			//clear listner 防止相关model再次读取数据时调用次接口
			event.model.removeEventListener( ModelEvent.COMPLETED, onRelatedCompleted );
			event.model.removeEventListener( ModelEvent.ERROR, onRelatedError );
			//TODO阻止其他请求
			this.onError();
		}
		
		public function get mapModel() :MapModel
		{
			return _map;
		}
		
		public function get scriptModel() :ScriptModel
		{
			return _script;
		}
		
		public function get unitModels() :Object
		{
			return _units;
		}
	}
}