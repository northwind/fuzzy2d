package controlers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.ISortable;
	import com.norris.fuzzy.map.geom.Coordinate;
	
	import controlers.events.TileEvent;
	
	import flash.display.DisplayObject;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	
	import views.MapItem;
	
	public class StaticLayer extends BaseLayer
	{
		private var _model:MapModel;
		private var _items:Object;
		private var _sortedItems:Array = [];
		
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
			
			//监听单元格事件
			tileLayer.addEventListener(TileEvent.MOVE, onMoveTile);
			tileLayer.addEventListener(TileEvent.SELECT, onSelectTile);
		}
		
		private function onSelectTile( event:TileEvent ):void
		{
			// TODO Auto Generated method stub
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