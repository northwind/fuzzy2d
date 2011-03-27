package screens
{
	import com.norris.fuzzy.core.display.impl.BaseScreen;
	import com.norris.fuzzy.core.display.impl.CentreScreen;
	
	import controlers.*;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	import models.impl.RecordModel;
	
	public class BattleScreen extends BaseScreen
	{
		public var mapLayer:MapLayer;
		public var model:RecordModel;
		
		public function BattleScreen(  model :RecordModel )
		{
			super();
			
			this.model = model;
			
			if ( model.data != null )
				this.initLayers();
			else
				model.addEventListener( ModelEvent.COMPLETED, initLayers );
		}
		
		protected function initLayers( event:ModelEvent = null ) :void
		{
			this.view.x = model.mapModel.offsetX;
			this.view.y = model.mapModel.offsetY;
			
			mapLayer  = new MapLayer( model.mapModel );

			var staticLayer:StaticLayer = new  StaticLayer( model.mapModel );
			var tileLayer:TileLayer = new TileLayer( model.mapModel );
			var unitsLayer:UnitsLayer = new UnitsLayer( model.mapModel );
			var tipsLayer:TipsLayer = new TipsLayer();
			
			this.push( mapLayer );
			this.push( tileLayer );
			this.push( staticLayer );
			this.push( unitsLayer );
			this.push( tipsLayer );
		}
		
		public function loadData() :void
		{
			model.loadData();
		}
	}
}