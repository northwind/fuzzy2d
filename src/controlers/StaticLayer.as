package controlers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	
	import flash.display.DisplayObject;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	
	import views.MapItem;
	
	public class StaticLayer extends BaseLayer
	{
		private var _model:MapModel;
		private var _items:Object;
		
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
			_items = _model.items;
			
			for each( var item:MapItem in _items ){
				this.view.addChild( item.view );
			}
		}
		
	}
}