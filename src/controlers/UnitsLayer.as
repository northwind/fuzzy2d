package controlers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	
	import models.impl.MapModel;
	
	public class UnitsLayer extends BaseLayer
	{
		public var cellLayer:TileLayer;
		public var tipsLayer:TipsLayer;
		
		public var model:MapModel;
		
		public function UnitsLayer( model:MapModel )
		{
			super();
			
			this.model = model;
		}
	}
}