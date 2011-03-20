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
	import flash.events.MouseEvent;
	
	import models.impl.MapModel;
	
	import views.tiles.*;
	
	public class TileLayer extends BaseLayer
	{
		private var _showgrid:Boolean = false;
		private var _gridct:Sprite = new Sprite();
		private var _paintCt:Sprite = new Sprite();
		
		private var _model:MapModel;
		private var _painted:Object = {};
		private var _select:SelectTile = new SelectTile();		
		private var _weight:uint;
		
		private var _lastRow:int = -9999; 
		private var _lastCol:int = -9999;
		
		public function TileLayer( model:MapModel )
		{
			super();
			
			this._model = model;
			this._weight = model.cellXNum;
			
			//添加到显示列表 取消显示时只隐藏不移除
			this.view.addChild( _gridct );
			this.view.addChild( _paintCt );
			this.view.addChild( _select );
			
			_select.x = -9999;
			
			this.showGrid();
			this.showMoves( [ [1,2], [1,3], [1,4], [1,2] ] );
			this.showAttacks(  [ [5,2], [5,3], [5,4], [5,2] ]  );
			
			MyWorld.instance.inputMgr.on( InputKey.MOUSE_MOVE, onMouseMove );
			
		}
		
		private function onMouseMove( event:MouseEvent ) : void
		{
		//	var coord:Coordinate = MyWorld.mapToIsoWorld( this.view.mouseX, this.view.mouseY );
//			var coord:Coordinate = MyWorld.mapToIsoWorld( this.view.mouseX, this.view.mouseY );
			var coord:Coordinate = MyWorld.mapToIsoWorld( event.localX , event.localY );
			
			var col:int = coord.x;
			var row:int = coord.y;
			
			if ( _lastRow == row && _lastCol == col )
				return;
			
			_lastRow = row;
			_lastCol   = col;
			
			trace( "col = " + col + " , row = " + row );
			
			coord = MyWorld.mapToScreen( row, col );
			
			_select.x  = coord.x;
			_select.y  = coord.y;			
		}
		
		public function showGrid() : void
		{
			if ( _gridct.numChildren > 0 ){
				_gridct.visible = true;
				return;
			}
			
			//++i
			for (var i:int = 0; i < this._model.cellXNum;++i) {
				for (var j:int = 0; j < this._model.cellYNum ;++j) {
					var tile:GridTile = new GridTile();
					//3d 换算为 屏幕对应的位置
					var coord:Coordinate = MyWorld.mapToScreen( i, j );
					
					tile.x = coord.x;
					tile.y = coord.y;
					
					_gridct.addChild( tile );
				}
			}
		}
		
		public function hideGrid() : void
		{
			_gridct.visible = false;
		}
		
		public function toggleGrid() : void
		{
			if ( _showgrid ){
				_showgrid = false;
				this.hideGrid();
			}else{
				_showgrid = true;
				this.showGrid();
			}
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