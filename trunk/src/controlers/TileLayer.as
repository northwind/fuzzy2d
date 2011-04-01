package controlers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.input.impl.InputKey;
	import com.norris.fuzzy.core.input.impl.InputManager;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.map.Isometric;
	import com.norris.fuzzy.map.geom.Coordinate;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import models.impl.MapModel;
	
	import views.tiles.*;
	
	public class TileLayer extends BaseLayer
	{
		public var coordLayer :DebugMsgLayer;
		
		private var _showgrid:Boolean = false;
		private var _coordable:Boolean = false;		//是否显示坐标
		
		private var _gridWrap:Sprite = new Sprite();
		private var _paintCt:Sprite = new Sprite();
		private var _select:SelectTile = new SelectTile();
		private var _movedTile:MoveTile = new MoveTile();
		
		private var _model:MapModel;
		private var _painted:Object = {};
				
		private var _weight:uint;

		private var w:Number;
		private var h:Number;
		private var outerWidth:Number;
		private var outerHeight:Number;
		
		private var _tileWidth:Number;
		private var _tileHeight:Number;
		
		private var minSum:uint;
		private var maxSum:uint;
		private var maxMinus:uint;
		
		private var _cols:int;
		private var _rows:int;
		
		private var _lastRow:int = -999;
		private var _lastCol:int = -999;
		
		private var _gridX:Number;
		private var _gridY:Number;
		private var _mouseMoveOffsetX:Number;
		
		private var _currentCoord:TextField;
		private var _iso:Isometric;
		private var _parentView:Sprite;
		
		public function TileLayer( model:MapModel )
		{
			super();
			
			this._model = model;
			this._weight = model.cellXNum;
			
			_iso = MyWorld.isometric;
			
			//figure out the width of the tile in 3D space
			_tileWidth = _iso.mapToIsoWorld( MyWorld.CELL_WIDTH, 0).x;
			
			//the tile is a square in 3D space so the height matches the width
			_tileHeight = _tileWidth;
			
			w =  model.cellYNum * MyWorld.CELL_WIDTH;
			h =  model.cellXNum * MyWorld.CELL_HEIGHT;
			
			//菱形的数量等于宽高单元格的个数相加
			_cols = model.cellXNum + model.cellYNum;
			_rows =  _cols;
			
			//设置有效范围
			minSum = _cols - model.cellXNum;
			maxSum = (_cols - 1) * 2 - minSum ;
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
			_gridWrap.y = -(_cols * MyWorld.CELL_HEIGHT - h) / 2 + model.background.oT;
			
			_gridX = _gridWrap.x;
			_gridY = _gridWrap.y;
			_mouseMoveOffsetX = MyWorld.CELL_WIDTH  /2;
			
//			this.setCoord();
			this.showCoord();
			this.showGrid();
			
			if ( this.view.stage )	
				onAddStage();
			else	
				this.view.addEventListener(Event.ADDED_TO_STAGE, onAddStage );
		}
		
		private function setCoord() :void {
			/* 坐标信息 */
			_currentCoord = new TextField();
			_currentCoord.textColor = 0xff0000;
			_currentCoord.width = 30;
			_currentCoord.height = 20;
			_currentCoord.background = true;
			_currentCoord.backgroundColor = 0xaaaaaa;
			_currentCoord.x = -1 * this.view.x + 20;
			_currentCoord.y = -1 *  this.view.y + 20;
			this.view.addChild( _currentCoord );			
		}

		protected function onAddStage( event:Event = null )  : void
		{
			this.view.removeEventListener(Event.ADDED_TO_STAGE, onAddStage );
			
			_parentView = this.view.parent as Sprite ;
			//MyWorld.instance.inputMgr.on( InputKey.MOUSE_MOVE, onMouseMove );
			_parentView.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
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
			
			/* 添加调试信息 */
			MyWorld.instance.debugMgr.unregisterCommand( "grid" );
			MyWorld.instance.debugMgr.unregisterCommand( "coord" );
		}
		
		private function onMouseMove( event:MouseEvent ) : void
		{
//			var coord:Coordinate = _iso.mapToIsoWorld( event.localX  - _mouseMoveOffsetX, 
//																							event.localY );
			var coord:Coordinate = _iso.mapToIsoWorld( _parentView.mouseX - _gridX - _mouseMoveOffsetX, 
																							_parentView.parent.mouseY - _gridY );
//			var coord:Coordinate = _iso.mapToIsoWorld( event.localX - _mouseMoveOffsetX, 
//																							event.localY );
			
			var row:int = Math.floor(Math.abs(coord.x / _tileWidth)) ;
			var col:int = Math.floor( Math.abs( coord.z ) / _tileHeight ) ;
			
			if ( _lastRow == row && _lastCol == col )
				return;
			
			_lastRow = row;
			_lastCol   = col;
			
			if ( _coordable && coordLayer )
				coordLayer.showMsg( row + "," + col );
//				_currentCoord.text = row + "," + col;
			
			//TODO 继续优化
			if ( isValid( row, col )  ){
				if ( _movedTile.visible == false )
					_movedTile.visible = true;
				
				coord = _iso.mapToScreen( row * _tileHeight, 0, -col * _tileWidth );
				
				_movedTile.x  = coord.x + _gridX;
				_movedTile.y  = coord.y + _gridY;				
			}else{
				_movedTile.visible = false;
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
			
			for (var i:int = 0; i < _rows;++i) {
				for (var j:int = 0; j < _cols;++j) {
					//只绘制落在可操控区域中的表格
					if ( !isValid( i, j ) )
						continue;
					
					var t:GridTile = new GridTile();
//					var t:DebugNumberTile = new DebugNumberTile( i,j );
					
					var tx:Number = i * _tileHeight;
					var tz:Number = -j * _tileWidth;
					
					var coord:Coordinate = _iso.mapToScreen(tx, 0, tz);
					
					t.x = coord.x;
					t.y = coord.y;
					
					_gridWrap.addChild(t);
				}
			}	
		}
		
		/**
		 *  校验单元格的有效性
		 *  相加最大值检验screen中的y，相减的绝对值校验screen中的x 
		 * @param x
		 * @param z
		 * @return 
		 * 
		 */		
		public function isValid( x:int, z:int ) : Boolean
		{
			var sum:int = x + z;
			var diff:uint = Math.abs( x - z );
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
//			
//			if ( !_currentCoord.visible )
//				return;
//			
//			_currentCoord.visible = false;
		}
		
		public function showCoord() :void
		{
			_coordable = true;
//			
//			if ( _currentCoord.visible )
//				return;
//			
//			_currentCoord.visible = true;
		}
		
		/**
		 *  一个格子只能放置一种颜色标识 
		 * @param x
		 * @param y
		 * @param tile
		 * 
		 */		
		public function paintTile( x:uint, y:uint, tile:DisplayObject  ) : void
		{
			var a:DisplayObject = this._painted[ x * this._weight + y ] as DisplayObject;
			if ( a != null )
				try{
					this._paintCt.removeChild( a );
				}catch(e:Error){}
			
			var coord:Coordinate = MyWorld.mapToScreen( x, y );
			
			tile.x = coord.x;
			tile.y = coord.y;
			
			this._painted[ x * this._weight + y ] = tile;
			
			this._paintCt.addChild( tile );
		}
		
		/**
		 * 显示可移动单元格 [ [x,y], [x,y], ... ] 
		 * @param positions
		 * 
		 */		
		public function showMoves( positions:Array ) : void
		{
			for each ( var position:Array in positions ){
				this.paintTile( position[0], position[1], new MoveTile() );
			}
		}
		
		/**
		 * 显示可攻击单元格 [ [x,y], [x,y], ... ] 
		 * @param positions
		 * 
		 */		
		public function showAttacks( positions:Array ) : void
		{
			for each ( var position:Array in positions ){
				this.paintTile( position[0], position[1], new AttackTile() );
			}
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
	}
}