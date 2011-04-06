package controlers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.map.IMapItem;
	import com.norris.fuzzy.map.geom.Coordinate;
	
	import flash.display.DisplayObject;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	
	import views.MapItem;
	
	public class StaticLayer extends BaseLayer
	{
		private var _model:MapModel;
		private var _items:Object;
		
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
					tileLayer.adjustPosition( item.view, item.row, item.col, item.rows, item.cols );
					
					this.view.addChild( item.view );
				}
			}
		}
		
	}
}