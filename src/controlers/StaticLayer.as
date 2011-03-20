package controlers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	
	import flash.display.DisplayObject;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	
	import screens.MapItem;
	
	public class StaticLayer extends BaseLayer
	{
		private var model:MapModel;
		private var _items:Object;
		
		public function StaticLayer( model :MapModel )
		{
			super();
		
			this.model = model; 
		}
		
		override public function onSetup() :void
		{
			if ( this.model.data == null )
				this.model.addEventListener( ModelEvent.COMPLETED, onModelCompleted );
			else 
				onModelCompleted();
		}
		
		private function onModelCompleted( event :ModelEvent = null ) :void
		{
				this._items = model.items;
				
				for each( var item:MapItem in model.items ){
					this.view.addChild( item.view );
				}
		}
		
	}
}