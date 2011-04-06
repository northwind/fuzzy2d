package controlers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	
	import models.impl.MapModel;
	import models.event.ModelEvent;
	
	public class UnitsLayer extends BaseLayer
	{
		public var cellLayer:TileLayer;
		public var tipsLayer:TipsLayer;
		
		private var _model:MapModel;
		private var _items:Object;
		
		public function UnitsLayer( model:MapModel )
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
			
		}
		
	}
}