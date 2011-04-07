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
		private var _itemsUnique:Object = {};
		private var _defines:BaseManager = new BaseManager();
		private var _blocks:Object = {};
		
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

				//存储障碍单元
				var blocks:Array;
				if ( value["blocks"] is Array ){
					blocks = value["blocks"] as Array;
				}else{
					blocks = [];
				}
				for each (var b:Object in blocks) {
					setBlockPos( b.r, b.c );					
				}
				
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
					item.row = a.r;
					item.col = a.c;
					item.offsetX = o.oX;
					item.offsetY = o.oY;
					item.cols 	 = o.cs;
					item.rows     = o.rs;
					item.isWalkable = o.w == 1 ? true : false;
					item.isOverlap = o.o == 1 ? true : false;
					
					addMapItem( item );
				}
				
				this.onCompleted( value );
			}
		}
		
		private function addMapItem( item:IMapItem ) : void
		{
			_itemsUnique[ item.row + "_" + item.col ] = item;
			//设置障碍单元
			for (var i:int = item.rows - 1; i >= 0; i-- ) 
			{
				this._items.reg( (item.row -i) + "_" + item.col, item );
			
				if ( !item.isWalkable )
					setBlockPos( item.row - i, item.col );
			}
			for (var j:int = item.cols - 1; j >= 0; j-- ) 
			{
				this._items.reg( item.row + "_" + ( item.col - j ), item );
				
				if ( !item.isWalkable )
					setBlockPos( item.row, item.col - j );
			}
		}
		
		public function setBlockPos( row:int, col:int ) : void
		{
			_blocks[ row+"_" + col ] = 1;
		}
		
		public function isBlock(  row:int, col:int ) : Boolean
		{
			return _blocks[ row+"_" + col ] === 1;
		}
		
		public function get blocks() :Object
		{
			return _blocks;
		}
		
		public function getItem( row:int, col:int ) :IMapItem
		{
			return _items.find( row +"_" + col ) as IMapItem;
		}
		
		public function get items() :Object
		{
			return this._itemsUnique;
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