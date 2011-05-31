package controlers.layers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.display.impl.ScrollLayerContainer;
	import com.norris.fuzzy.core.input.impl.InputKey;
	import com.norris.fuzzy.core.input.impl.InputManager;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.Isometric;
	import com.norris.fuzzy.map.astar.Astar;
	import com.norris.fuzzy.map.astar.ISearchable;
	import com.norris.fuzzy.map.astar.Node;
	import com.norris.fuzzy.map.astar.Path;
	import com.norris.fuzzy.map.geom.Coordinate;
	
	import controlers.events.TileEvent;
	import controlers.unit.IRange;
	import controlers.unit.impl.Range;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import models.impl.MapModel;
	
	import views.tiles.*;
	
	[Event(name="move", type="controlers.events.TileEvent")]
	
	[Event(name="select", type="controlers.events.TileEvent")]
	
	/**
	 *  处理与单元格相关的逻辑
	 *  TODO 优化显示方式，采用Shape/fillBitmap方式绘制单元格 
	 * @author Administrator
	 * 
	 */	
	public class TileLayer extends BaseLayer implements ISearchable
	{
		public var coordLayer :DebugMsgLayer;
		public var scrollLayer:ScrollLayerContainer;
		public var unitsLayer:UnitsLayer;
		public var currentNode:Node;					//当前单元格
		public var astar:Astar;
		
		public var cols:int;								//2.5d世界中列数
		public var rows:int;						    //2.5d世界中行数
		
		private var _showgrid:Boolean = false;
		private var _coordable:Boolean = false;		//是否显示坐标
		private var _mousedown:Boolean = false;	//记录是否移动
		private var _mousemove:Boolean = false;	//记录是否移动
		
		private var _gridWrap:Sprite = new Sprite();
		private var _paintCt:Sprite = new Sprite();
		private var _select:SelectTile = new SelectTile();
		private var _movedTile:MoveTile = new MoveTile();
		
		private var _model:MapModel;
		private var _painted:Object = {};
		
		private var w:Number;						//有效操作区域宽度
		private var h:Number;						//有效操作区域高度
		
		private var _tileWidth:Number;		//2.5D中格子宽
		private var _tileHeight:Number;     //2.5D中格子高
		
		private var minSum:uint;					//单元格X和Z轴值相加最小值
		private var maxSum:uint;                //单元格X和Z轴值相加最大值
		private var maxMinus:uint;             //单元格X和Z轴值相减的绝对值的最大值
		
		private var _grid:Array = [];						//存放单元格，用于搜索路径
		
		private var _lastRow:int = -999;							//移动单元格上次坐标
		private var _lastCol:int = -999;
		
		private var _gridX:Number;									//格子整体的X偏移量
		private var _gridY:Number;									//格子整体的X偏移量
		private var _mouseMoveOffsetX:Number;		//鼠标移动时X的偏移量
		
		private var _iso:Isometric;
		private var _parentView:Sprite;		//父容器
		
		public function TileLayer( model:MapModel )
		{
			super();
			
			this._model = model;
			
			_iso = MyWorld.isometric;
			
			//figure out the width of the tile in 3D space
			_tileWidth = _iso.mapToIsoWorld( MyWorld.CELL_WIDTH, 0).x;
			
			//the tile is a square in 3D space so the height matches the width
			_tileHeight = _tileWidth;
			
			w =  model.cellYNum * MyWorld.CELL_WIDTH;
			h =  model.cellXNum * MyWorld.CELL_HEIGHT;
			
			//菱形的数量等于宽高单元格的个数相加
			cols = model.cellXNum + model.cellYNum;
			rows =  cols;
			
			//设置有效范围
			minSum = cols - model.cellXNum;
			maxSum = (cols - 1) * 2 - minSum ;
			maxMinus = model.cellYNum - 1;
			
			_movedTile.visible = false;
			_gridWrap.mouseEnabled = false;
			_gridWrap.mouseChildren = false;
			
			//添加到显示列表 取消显示时只隐藏不移除
			this.view.addChild( _gridWrap );
			this.view.addChild( _paintCt );
			this.view.addChild( _movedTile );
			
			//设置3d世界坐标偏移量
			_gridWrap.x = w / 2 -  MyWorld.CELL_WIDTH / 2 + model.background.oL;
			_gridWrap.y = -(cols * MyWorld.CELL_HEIGHT - h) / 2 + model.background.oT;
			
			_gridX = _gridWrap.x;
			_gridY = _gridWrap.y;
			_mouseMoveOffsetX = MyWorld.CELL_WIDTH  /2;
			
			this.showCoord();
			this.showGrid();
			
			if ( this.view.stage )	
				onAddStage();
			else	
				this.view.addEventListener(Event.ADDED_TO_STAGE, onAddStage );
			
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}

		protected function onSetupCompleted(event:Event):void
		{
			this.removeEventListener(Event.COMPLETE, onSetupCompleted );
			
			astar= new Astar( this );
			Range.tileLayer = this;			
		}
		
		protected function onAddStage( event:Event = null )  : void
		{
			this.view.removeEventListener(Event.ADDED_TO_STAGE, onAddStage );
			
			_parentView = this.view.parent as Sprite ;
			//MyWorld.instance.inputMgr.on( InputKey.MOUSE_MOVE, onMouseMove );
			_parentView.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
			MyWorld.instance.inputMgr.on( InputKey.MOUSE_UP, onMouseUp );
			MyWorld.instance.inputMgr.on( InputKey.MOUSE_LEFT, onMouseDown );
			MyWorld.instance.inputMgr.on( InputKey.MOUSE_OUT, onMouseOut );
			MyWorld.instance.inputMgr.on( InputKey.MOUSE_OVER, onMouseOver );
			
			/* 添加调试信息 */
			MyWorld.instance.debugMgr.registerCommand( "grid", toggleGrid, "toggle grid." );
			MyWorld.instance.debugMgr.registerCommand( "coord", toggleCoord, "toggle coord." );
			
			this.view.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage );
		}
		
		private function onRemoveStage( event:Event ) : void
		{
			this.view.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage );
			
			_parentView.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			MyWorld.instance.inputMgr.un( InputKey.MOUSE_OUT, onMouseOut );
			MyWorld.instance.inputMgr.un( InputKey.MOUSE_OVER, onMouseOver );
			MyWorld.instance.inputMgr.un( InputKey.MOUSE_UP, onMouseUp );
			MyWorld.instance.inputMgr.un( InputKey.MOUSE_LEFT, onMouseDown );
//			MyWorld.instance.inputMgr.un( InputKey.CLICK, onClick );
			
			/* 添加调试信息 */
			MyWorld.instance.debugMgr.unregisterCommand( "grid" );
			MyWorld.instance.debugMgr.unregisterCommand( "coord" );
		}
		
		protected function onMouseDown( event:MouseEvent ):void
		{
			_mousedown = true;
		}
		/**
		 *  移动鼠标 
		 * @param event
		 * 
		 */		
		private function onMouseMove( event:MouseEvent ) : void
		{
			var coord:Coordinate = _iso.mapToIsoWorld( _parentView.mouseX - _gridX - _mouseMoveOffsetX, 
																						   _parentView.mouseY - _gridY );
			
			var row:int = Math.floor(Math.abs(coord.x / _tileWidth)) ;
			var col:int = Math.floor( Math.abs( coord.z ) / _tileHeight ) ;
			
			if ( _lastRow == row && _lastCol == col )
				return;
			
			if ( _mousedown )
				_mousemove = true;
			
			_lastRow = row;
			_lastCol   = col;
			
			if ( _coordable && coordLayer ){
				coordLayer.showMsg( row + "," + col );
			}
			
			//TODO 继续优化 将坐标对应位置存储起来，不在计算
			if ( isValid( row, col )  ){
				if ( _movedTile.visible == false )
					_movedTile.visible = true;
				
				coord = _iso.mapToScreen( row * _tileHeight, 0, -col * _tileWidth );
				
				_movedTile.x  = coord.x + _gridX;
				_movedTile.y  = coord.y + _gridY;
				
				currentNode = getNode( row, col );
				
				this.dispatchEvent( new TileEvent( TileEvent.MOVE, row, col, currentNode ) );
			}else{
				_movedTile.visible = false;
			}			

		}
		
		/**
		 * 调整mapItem显示位置 
		 * @param item
		 * 
		 */		
		public function adjustPosition( item:IMapItem ) : void
		{
			var row:int = item.row;
			var col:int = item.col;
			var view:DisplayObject = item.view;
			
			//不在显示范围内的，隐藏
			if ( !isValid( row, col ) ){
				view.visible = false;
				return;
			}
			var coord:Coordinate = _iso.mapToScreen( row * _tileHeight, 0, -col * _tileWidth );
			
			view.x = coord.x + _gridX - (item.rows - 1)* MyWorld.CELL_WIDTH / 2 + item.offsetX;
			view.y = coord.y + _gridY - (view.height - MyWorld.CELL_HEIGHT )  + item.offsetY ;
		}
		
		/**
		 * 转化为屏幕中的位置 
		 * @param point
		 * 
		 */		
		public function toScreen( point:Point ) : void
		{
			point.x = point.x + this.view.x;
			point.y = point.y + this.view.y;
			this.scrollLayer.toScreen( point );
		}
		
		/**
		 *  鼠标松开时才会触发选中事件 
		 * @param event
		 * 
		 */		
		private function onMouseUp( event:MouseEvent ) : void
		{
			var coord:Coordinate = _iso.mapToIsoWorld( _parentView.mouseX - _gridX - _mouseMoveOffsetX, 
				_parentView.mouseY - _gridY );
			
			var row:int = Math.floor(Math.abs(coord.x / _tileWidth)) ;
			var col:int = Math.floor( Math.abs( coord.z ) / _tileHeight ) ;
			//移动时不触发点击事件
			if ( isValid( row, col ) && !_mousemove ){
				this.dispatchEvent( new TileEvent( TileEvent.SELECT, row, col, getNode( row, col ) ) );				
			}
			_mousedown = false;
			_mousemove = false;
		}
		
		private function onClick( event:MouseEvent ):void
		{
			var coord:Coordinate = _iso.mapToIsoWorld( _parentView.mouseX - _gridX - _mouseMoveOffsetX, 
				_parentView.mouseY - _gridY );
			
			var row:int = Math.floor(Math.abs(coord.x / _tileWidth)) ;
			var col:int = Math.floor( Math.abs( coord.z ) / _tileHeight ) ;
			
			if ( isValid( row, col )  ){
				this.dispatchEvent( new TileEvent( TileEvent.SELECT, row, col ) );				
			}
		}
		
		private function onMouseOut( event:Event ) : void
		{
			this._movedTile.visible = false;
		}
		private function onMouseOver( event:Event ) : void
		{
			this._movedTile.visible = true;
		}
		
		public function showGrid() : void
		{
			_showgrid = true;
			
			if ( _gridWrap.numChildren > 0 ){
				_gridWrap.visible = true;
				return;
			}
			
			for (var i:int = 0; i < rows;++i) {
				_grid[i] = [];
				for (var j:int = 0; j < cols;++j) {
					//只绘制落在可操控区域中的表格
					if ( !isValid( i, j ) )
						continue;
					
					var t:GridTile = new GridTile();
//					var t:DebugNumberTile = new DebugNumberTile( i,j );
//					var t:DebugBlockTile = new DebugBlockTile( i,j, _model.isBlock( i, j ) );
					
					var tx:Number = i * _tileHeight;
					var tz:Number = -j * _tileWidth;
					
					var coord:Coordinate = _iso.mapToScreen(tx, 0, tz);
					
					t.x = coord.x;
					t.y = coord.y;
					
					_gridWrap.addChild(t);
					
					var node:Node = new Node( i, j ) ;
					
					node.originX = coord.x + _gridX;
					node.originY = coord.y + _gridY;
					node.centerX = coord.x + _gridX +  MyWorld.CELL_WIDTH / 2;
					node.centerY = coord.y + _gridY + MyWorld.CELL_HEIGHT / 2;
					
					_grid[i][j] = node;
				}
			}
		}
		
		/**
		 *  对其他层提供查询接口 
		 * @param row
		 * @param col
		 * @return 
		 * 
		 */		
		public function getNode( row:int, col:int ) :Node
		{
			var r :Array = _grid[ row ] as Array;
			if ( r == null )
				return null;
			
			return r[ col ] as Node;
		}
		
		/**
		 *  校验单元格的有效性
		 *  相加最大值检验screen中的y，相减的绝对值校验screen中的x 
		 * @param x
		 * @param z
		 * @return 
		 * 
		 */		
		public function isValid( row:int, col:int ) : Boolean
		{
			var sum:int = row + col;
			var diff:uint = Math.abs( row - col );
			if ( sum >= minSum && sum <= maxSum && diff <= maxMinus )
				return true;
			else
				return false;
		}
		
		public function hideGrid() : void
		{
			_showgrid = false;
			_gridWrap.visible = false;
		}
		
		public function toggleGrid() : void
		{
			if ( _showgrid ){
				this.hideGrid();
			}else{
				this.showGrid();
			}
		}
		
		public function toggleCoord() : void
		{
			if ( _coordable )
				hideCoord();
			else
				showCoord();
		}
		
		public function hideCoord() :void
		{
			_coordable = false;
		}
		
		public function showCoord() :void
		{
			_coordable = true;
		}
		
		/**
		 * 采用bitmapData绘制单元格
		 */		
		public function paintRange( range:IRange, bitmapData:BitmapData ) : void
		{
			var bitmap:Bitmap;
			for each ( var node:Node in range.nodes ){
				bitmap = new Bitmap( bitmapData );
				bitmap.x = node.originX;
				bitmap.y = node.originY;
				_paintCt.addChild( bitmap );
			}
		}
		
		/**
		 * 采用bitmapData绘制单元格
		 */		
		public function paintNodes( nodes:Array, bitmapData:BitmapData ) : void
		{
			var bitmap:Bitmap;
			for each ( var node:Node in nodes ){
				bitmap = new Bitmap( bitmapData );
				bitmap.x = node.originX;
				bitmap.y = node.originY;
				_paintCt.addChild( bitmap );
			}
		}
		
		/**
		 * 清空已显示的node 
		 */		
		public function clear() :void
		{
			while( _paintCt.numChildren > 0 )
				_paintCt.removeChildAt( 0 );
		}
		
		/**
		 * 显示被选中单元格  [x,y] 
		 * @param position
		 * 
		 */		
		public function showSelect( position:Array ) : void
		{
			if ( position == null )
				return;
			
			var coord:Coordinate = MyWorld.mapToScreen( position[0], position[1] );
			
			_select.x = coord.x;
			_select.y = coord.y;
		}

		public function getCols():int 
		{
			return this.cols;
		}
		
		public function getRows():int
		{
			return this.rows;
		}
		
		public	function getNodeTransitionCost(n1:Node, n2:Node):Number
		{
			var cost:Number = 1;
			if ( _model.isBlock( n1.row, n1.col ) || _model.isBlock( n2.row, n2.col ) )
				cost = 10000;
			
			return cost;
		}
		
		/**
		 * 寻路 
		 * @param walker
		 * @param target
		 * @return 
		 * 
		 */		
		public function findPath( from:Node, to:Node ):Path
		{
			return astar.search( from, to );
		}
	}
}