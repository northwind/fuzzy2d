package controlers
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
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	
	import views.MapItem;
	
	public class StaticLayer extends BaseLayer
	{
		private var _model:MapModel;
		private var _items:Object;
		private var _sortedItems:Array = [];
		private var _astar:Astar;
		
		public var tileLayer:TileLayer;
		
		public function StaticLayer( model :MapModel )
		{
			super();
		
			this._model = model; 
		}
		
		override public function onSetup() :void
		{
			if ( this._model.data == null )
				this._model.addEventListener( ModelEvent.COMPLETED, onModelCompleted );
			else 
				onModelCompleted();
		}
		
		private function onModelCompleted( event :ModelEvent = null ) :void
		{
			this._model.removeEventListener( ModelEvent.COMPLETED, onModelCompleted );
			
			_items = _model.items;
			
			var coord:Coordinate;
			for each( var item:IMapItem in _items ){
				if ( item.view != null ){
					tileLayer.adjustPosition( item );
					
					this.view.addChild( item.view );
					
					_sortedItems.push( item );
				}
			}
			
			render();
			
			_astar = new Astar( tileLayer );
			
			//监听单元格事件
			tileLayer.addEventListener(TileEvent.MOVE, onMoveTile);
			tileLayer.addEventListener(TileEvent.SELECT, onSelectTile);
		}
		
		private function onSelectTile( event:TileEvent ):void
		{
			var row:int = event.row;
			var col:int = event.col;
			
			if ( !this.isWalkable(row, col ) )
				return;
			
			var goalNode:Node = tileLayer.getNode( row, col );
			if ( goalNode == null )
				return;
			
			var startNode:Node = tileLayer.getNode( 6, 20 );
			if ( startNode == null )
				return;
			
			var results:Path = _astar.search(startNode, goalNode);
			if ( results ) {
				Logger.debug( "success" );
				walk( results );
			}
			
		}
		
		private function walk( path:Path ) : void
		{
			var t:Timer =new Timer( 250, path.nodes.length );
			var n:int = 0, current:Node, 
				item:IMapItem = this._model.getItem( 6, 20 );
			t.addEventListener(TimerEvent.TIMER, function( event:TimerEvent ) : void {
				if ( n < path.nodes.length ){
					current = path.nodes[ n++ ] as Node;
					
					item.row = current.row;
					item.col = current.col;
					
					tileLayer.adjustPosition( item );
					
					render();
				}else{
					t.stop();
				}
			});
			
			t.start();
		}
		
		private function isWalkable( row:int, col:int ) : Boolean
		{
			//TODO 友军敌军判断
			return !_model.isBlock( row, col );		
		}
		
		private var _lastMoveItem:IMapItem = null;
		private function onMoveTile( event:TileEvent ):void
		{
			var item:IMapItem = this._model.getItem( event.row, event.col );
			if (  _lastMoveItem != item && _lastMoveItem != null )
				_lastMoveItem.view.alpha = 1;
			
			if ( item == null )
				return;
			
			_lastMoveItem = item;
			
			item.view.alpha = 0.5;
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
			
			for (i = 0; i < _sortedItems.length;++i) {
				var disp:IMapItem = _sortedItems[i] as IMapItem;
				this.view.addChildAt(disp.view, i);
			}
		}
	}
}