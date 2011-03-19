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
		}
	}
}