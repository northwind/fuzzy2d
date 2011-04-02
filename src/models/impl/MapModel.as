package models.impl
{
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	import flash.events.IEventDispatcher;
	
	import views.MapItem;
	
	import server.*;
	
	public class MapModel extends BaseModel
	{
		public var id:String;
		public var cellXNum:uint = 0;
		public var cellYNum:uint = 0;
		//弃用 改用MyWorld中静态变量
		public var cellWidth:uint = 0;
		public var cellHeight:uint = 0;
		
		private var _items:BaseManager = new BaseManager();
		private var _defines:BaseManager = new BaseManager();
		
		public function MapModel( id:String = null )
		{
			super();
			
			if ( id != null )
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
			else{
				cellXNum = value[ "cellXNum" ];
				cellYNum = value[ "cellYNum" ];
				cellWidth = value[ "cellWidth" ];
				cellHeight = value[ "cellHeight" ];
				
				//存储item define
				var defines:Array;
				if ( value["defines"] is Array ){
					defines = value["defines"] as Array;
				}else{
					defines = [];
				}
				
				for each( var d:Object in defines ){
					this._defines.reg( d.id, d );
				}
				
				//生成items				
				var items:Array = value["items"] as Array;
				if ( items == null )
					items = [];
				
				var  o:Object, item:MapItem;
				for each( var a:Object in items){
					item = new MapItem();
					
					item.raw = a.x;
					item.col = a.y;
					item.define   = a.d;

					this._items.reg( a.x + "_" + a.y, item );
					
					//复制属性
					o = this._defines.find( a.d );
					if ( o == null )
						continue;
					
					item.src = o.s;
					item.offsetX = o.oX;
					item.offsetY = o.oY;
					item.cols 	 = o.cs;
					item.raws     = o.rs;
					item.walkable = o.w == 1 ? true : false;
					item.overlap = o.o == 1 ? true : false;
				}
				
				this.onCompleted( value );
			}
		}
		
		public function get items() :Object
		{
			return this._items.getAll();
		}
		
		public function get background() :Object
		{
			if ( this._data == null )
				return {};
			
			return this._data["bg"];
		}
		
		/**
		 * 需要下载的资料列表  [ [id, src], ... ] 
		 * @return 
		 * 
		 */		
		public function get  defineSrcs() :Array
		{
			var ret:Array = [];
			
			if ( this._data == null || !this._data["defines"] is Array )
				return ret;
			
			for each( var d:Object in this._data["defines"] ){
				ret.push( [ d.id, d.src ] );
			}
			
			return ret;
		}
		
		public function get offsetX() :int
		{
			if ( this._data == null )
				return 0;
			
			return this._data[ "oX" ];
		}
		
		public function get offsetY() :int
		{
			if ( this._data == null )
				return 0;
			
			return this._data[ "oY" ];
		}
	}
}