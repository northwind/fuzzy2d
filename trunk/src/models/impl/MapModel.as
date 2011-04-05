package models.impl
{
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	import com.norris.fuzzy.core.resource.impl.SWFResource;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.item.ImageMapItem;
	import com.norris.fuzzy.map.item.MapItemType;
	import com.norris.fuzzy.map.item.SWFMapItem;
	
	import flash.events.IEventDispatcher;
	
	import server.*;
	
	import views.MapItem;
	
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
				
				var  o:Object, item:IMapItem, itemType:int;
				for each( var a:Object in items){
					//查找对应的定义
					o = this._defines.find( a.d );
					if ( o == null || a.d == undefined )
						continue;
					
					itemType = o.type ||  MapItemType.IMAGE ;
					if( itemType == MapItemType.IMAGE ){
						item = new ImageMapItem();
					} else if( itemType == MapItemType.SWF ){
						item = new SWFMapItem( o.sb );
					}
					else
						continue;
					
					item.define = a.d;
					item.row = a.x;
					item.col = a.y;
					item.offsetX = o.oX;
					item.offsetY = o.oY;
					item.cols 	 = o.cs;
					item.rows     = o.rs;
					item.isWalkable = o.w == 1 ? true : false;
					item.isOverlap = o.o == 1 ? true : false;
					
					this._items.reg( a.x + "_" + a.y, item );
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
		public function get  defines() :Array
		{
			var ret:Array = [];
			
			if ( this._data == null || !this._data["defines"] is Array )
				return ret;
			
			for each( var d:Object in this._data["defines"] ){
				ret.push( [ d.id, d.s ] );
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