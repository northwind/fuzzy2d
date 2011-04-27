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
	import controlers.unit.impl.Range;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	
	import views.MapItem;
	
	public class StaticLayer extends BaseLayer
	{
		private var _model:MapModel;
		private var _items:Object;
		private var _sortedItems:Array = [];
		private var _blocks:Object = {};
		
		public var tileLayer:TileLayer;
		
		public function StaticLayer( model :MapModel )
		{
			super();
		
			this._model = model; 
		}
		
		public function isBlock( row:int, col:int ):Boolean
		{
			return _model.isBlock( row, col ) || _blocks[ row + "_" + col ] != undefined;
		}
		
		override public function onSetup() :void
		{
			if ( this._model.data == null )
				this._model.addEventListener( ModelEvent.COMPLETED, onModelCompleted );
			else 
				onModelCompleted();
			
			Range.staticLayer = this;
		}
		
		private function onModelCompleted( event :ModelEvent = null ) :void
		{
			this._model.removeEventListener( ModelEvent.COMPLETED, onModelCompleted );
			
			_items = _model.items;
			
			var coord:Coordinate, i:int, j:int;
			for each( var item:IMapItem in _items ){
				if ( item.view != null ){
					tileLayer.adjustPosition( item );
					
					this.view.addChild( item.view );
					
					_sortedItems.push( item );
					
					//设置障碍单元
					if ( !item.isWalkable ){
						for (i = 0; i < item.rows ; i++) 
						{
							for ( j = 0; j < item.cols; j++) 
							{
								_blocks[ (item.row - i) + "_" + (item.col - j ) ] = true;								
							}
						}
					}
				}
			}
			
			view.scrollRect = new Rectangle( 0, 0, _model.totalWidth, _model.totalHeight);
			//hack 让宽高立即生效
			var bmpData:BitmapData = new BitmapData(1, 1);
			bmpData.draw( view );
			
			render();
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