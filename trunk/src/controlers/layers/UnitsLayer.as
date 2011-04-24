package controlers.layers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.ISortable;
	import com.norris.fuzzy.map.astar.Astar;
	import com.norris.fuzzy.map.astar.Node;
	import com.norris.fuzzy.map.astar.Path;
	import com.norris.fuzzy.map.geom.Coordinate;
	
	import controlers.events.TileEvent;
	import controlers.events.UnitEvent;
	import controlers.unit.IFigure;
	import controlers.unit.Unit;
	import controlers.unit.impl.*;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	import models.impl.RecordModel;
	import models.impl.SkillModel;
	import models.impl.StuffModel;
	import models.impl.UnitModel;
	
	/**
	 * 统筹管理unit，并分配用户的操作，不直接响应用户的操作 
	 * @author norris
	 * 
	 */	
	public class UnitsLayer extends BaseLayer
	{
		public var tileLayer:TileLayer;
		public var tipsLayer:TipsLayer;
		public var staticLayer:StaticLayer;
		public var actionLayer:ActionLayer;
		
		private var _recordModel:RecordModel;
		private var _units:Object;
		private var _unitsPos:Object;
		private var _sortedItems:Array = [];
		
		private var _astar:Astar;
		private var _lastMoveRow:int = 6;
		private var _lastMoveCol:int = 20;
		
		private var _selectUnit:Unit;
		
		public function UnitsLayer( model:RecordModel )
		{
			super();
			
			this._recordModel = model;
			this._unitsPos = {};
		}
		
		override public function onSetup() :void
		{
			if ( this._recordModel.data == null )
				this._recordModel.addEventListener( ModelEvent.COMPLETED, onModelCompleted );
			else 
				onModelCompleted();
		}
		
		private function onModelCompleted( event :ModelEvent = null ) :void
		{
			this._recordModel.removeEventListener( ModelEvent.COMPLETED, onModelCompleted );
			
			var models:Object = this._recordModel.unitModels;
			
			_units = {};
			var coord:Coordinate, unit:Unit, mapItem:IMapItem;
			for each( var model:UnitModelComponent in models ){
				unit = new Unit();
				unit.layer = this;
				unit.addComponent( model );
				unit.addComponent( new BaseMoveable() );
				unit.addComponent( new BaseFigure() );
				if ( model.bodyAttack != 0 )
					unit.addComponent( new BaseAttack() );	
				//技能和物品
				for each (var sk:SkillModel in model.skills ) {
					unit.addComponent( new BaseSkill( sk ) );					
				}
				for each (var sf:StuffModel in model.stuffs ) {
					unit.addComponent( new BaseStuff( sf ) );					
				}
				unit.setup();
				 
				_units[ model.id ] = unit;
				_unitsPos[ generateKey( model.row, model.col ) ] = unit;
				 
				if ( unit.figure != null && unit.figure.mapItem != null ){
					mapItem = unit.figure.mapItem;
					tileLayer.adjustPosition( mapItem );
					
					_sortedItems.push( mapItem );
					
					//延迟加载，加载好后调用onFigureComplete
					unit.figure.addEventListener( Event.COMPLETE, onFigureComplete );
				}
			}
			
			render();
			
			//使用unitsLayer做为Astar寻路的容器
			_astar = new Astar( tileLayer );
			
			//监听单元格事件
			tileLayer.addEventListener(TileEvent.MOVE, onMoveTile);
			tileLayer.addEventListener(TileEvent.SELECT, onSelectTile);			
		}
		
		//重新排序
		private function onFigureComplete( event:Event ):void
		{
			var f:IFigure =event.target as IFigure; 
			f.removeEventListener( Event.COMPLETE, onFigureComplete );
			
			tileLayer.adjustPosition( f.mapItem );
			render();
		}
		
		private function isActive() :Boolean
		{
			return true;
		}
		
		private function onSelectTile( event:TileEvent ):void
		{
			if ( !isActive() )
				return;
			
			var unit:Unit = getUnitByPos( event.row, event.col );
			if ( _selectUnit == null ){
				//当前没有操作对象且点在空地上时，什么都不做
				if ( unit == null )
					return;
				
				_selectUnit = unit;
				_selectUnit.select();
				
				//显示移动、攻击范围
				
			  	//显示操作菜单
				
			}else{
				if ( _selectUnit != unit ){
					_selectUnit.unselect();
				}
				
				if ( unit == null ){
					return;
				}else{
					_selectUnit = unit;
					_selectUnit.select();
				}
				
			}
			
			
			
			return;
			
			var row:int = event.row;
			var col:int = event.col;
			
			if ( !this.isWalkable(row, col ) )
				return;
			
			var goalNode:Node = tileLayer.getNode( row, col );
			if ( goalNode == null )
				return;
			
			var startNode:Node = tileLayer.getNode( _lastMoveRow, _lastMoveCol );
			if ( startNode == null )
				return;
			
			var results:Path = _astar.search(startNode, goalNode);
			if ( results ) {
				//监听移动事件
				this._selectUnit.addEventListener(UnitEvent.MOVE, onUnitMove, false, 0, true );
				this._selectUnit.walkPath( results );
			}
			
		}
		
		private var _lastMoveItem:IMapItem = null;
		private function onMoveTile( event:TileEvent ):void
		{
			var item:IMapItem = this._recordModel.mapModel.getItem( event.row, event.col );
			if (  _lastMoveItem != item && _lastMoveItem != null )
				_lastMoveItem.view.alpha = 1;
			
			if ( item == null )
				return;
			
			_lastMoveItem = item;
			
			//TODO 显示角色基本信息
		}
		
		private function isWalkable( row:int, col:int ) : Boolean
		{
			//TODO 友军敌军判断
			return !_recordModel.mapModel.isBlock( row, col );		
		}
		
		private function walk( path:Path ) : void
		{
			var t:Timer =new Timer( 100, path.nodes.length );
			var n:int = 0, current:Node, 
				item:IMapItem = _selectUnit.figure.mapItem;
			
			t.addEventListener(TimerEvent.TIMER, function( event:TimerEvent ) : void {
				current = path.nodes[ n++ ] as Node;
				
				item.row = current.row;
				item.col = current.col;
				
				tileLayer.adjustPosition( item );
				
				render();
			});
			t.addEventListener(TimerEvent.TIMER_COMPLETE, function( event:TimerEvent ): void{
				var lastNode:Node = path.nodes[ path.nodes.length - 1 ] as Node;
				_lastMoveRow = lastNode.row;
				_lastMoveCol = lastNode.col;
			});
			
			t.start();
		}
		
		public function getUnit( id:String ) :Unit
		{
			return _units[ id ] as Unit;
		}
		
		private function generateKey( row:int, col:int ) :String
		{
			return row + "_" + col;
		}
		
		public function getUnitByPos( row:int, col:int ) :Unit
		{
			return _unitsPos[ generateKey( row, col) ] as Unit;
		}
		
		public function getUnitByNode( node:Node ) :Unit
		{
			return _unitsPos[ generateKey( node.row, node.col) ] as Unit;
		}
		
		/**
		 * 每当有item更改位置时，需要调用该方法，重新排序 
		 * 
		 */		
		public function render() : void
		{
			sortAllItems();
		}
		
		private function sortAllItems() : void 
		{
			var list:Array = _sortedItems.slice(0);
			
			_sortedItems = [];
			
			for (var i:int = 0; i < list.length;++i) {
				var nsi:ISortable = list[i];
				
				var added:Boolean = false;
				for (var j:int = 0; j < _sortedItems.length;++j ) {
					var si:ISortable = _sortedItems[j];
					
					if (nsi.col <= si.col && nsi.row <= si.row ) {
						_sortedItems.splice(j, 0, nsi);
						added = true;
						break;
					}
				}
				if (!added) {
					_sortedItems.push(nsi);
				}
			}
			
			while( this.view.numChildren>0 )
				this.view.removeChildAt( 0 );
			
			for (i = 0; i < _sortedItems.length;++i) {
				var disp:IMapItem = _sortedItems[i] as IMapItem;
				this.view.addChildAt(disp.view, i);
			}
		}
		
		protected function onUnitMove(event:UnitEvent):void
		{
			var unit:Unit = event.unit;
			
			this.tileLayer.adjustPosition( unit.figure.mapItem );
			this.render();
		}
		
	}
}