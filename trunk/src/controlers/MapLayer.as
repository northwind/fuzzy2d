package controlers
{
	import com.norris.fuzzy.core.display.impl.ImageLayer;
	import com.norris.fuzzy.core.resource.impl.ImageResource;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	
	public class MapLayer extends ImageLayer
	{
		public var model:MapModel;
		
		public function MapLayer( model:MapModel )
		{
			super();
			
			this.model = model;
			
			model.addEventListener( ModelEvent.COMPLETED, onModelCompleted );
		}
		
		private function onModelCompleted( event:ModelEvent ) : void
		{
			this.dataSource = new ImageResource( "bg", this.model.bgPath, true );
		}
		
	}
}