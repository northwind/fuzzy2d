package models.impl
{
	import controlers.unit.impl.UnitModelComponent;
	
	import models.IDataModel;
	import models.event.ModelEvent;
	
	import server.*;
	
	public class RecordModel extends BaseModel implements IDataModel
	{
		public var id:String = "";
		public var teams:Array = [];
		public var myTeamModel:TeamModel;
		
		private var _map:MapModel;
		private var _script:ScriptModel;
		private var _units:Object;
		private var _unitsPos:Object;
		
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
				var teams:Array = value["teams"] as Array;
				if ( teams == null ){
					this.onError();
					return;
				}
				
				this._relates = 2;			//需要下载的资源数
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
				var u:UnitModelComponent, id:String, team:TeamModel, obj:Object, i :int, m :Array;
				for( var j:uint=0; j <teams.length; j++ ){
					obj = teams[ j ];
					//new a team
					team = new TeamModel( obj.na, obj.fa, obj.tm );
					if ( obj.my === true )
						myTeamModel = team;
						
					m = obj.m is Array ? obj.m as Array : [];
					//add related download count
					_relates += m.length;
					
					for( i=0; i < m.length; i++ ){
						id = m[i]["id"];
						if ( id == null || id == "" ){
							this._relates--;	//减少下载数量
							continue;
						}
						//u = new UnitModel( id , units[i] );
						u = new UnitModelComponent( id , m[i] );
						u.addEventListener( ModelEvent.COMPLETED, onRelatedCompleted );
						u.addEventListener( ModelEvent.ERROR, onRelatedError );
						u.loadData();
						
						_units[ id ] = u;
						u.teamModel = team;
						team.addUnitModel( u );
					}
					
					this.teams.push( team );
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
		
		public function getUnitModel( row:int, col:int ):UnitModel
		{
			return _unitsPos[ row + "_" + col ] as UnitModel;
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