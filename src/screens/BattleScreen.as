package screens
{
	import com.norris.fuzzy.core.display.impl.BaseScreen;
	
	import controlers.*;
	
	import models.impl.MapModel;
	
	public class BattleScreen extends BaseScreen
	{
		private var mapLayer:MapLayer;
		private var model:MapModel;
		
		public function BattleScreen()
		{
			super();
			
			this.initLayers();
		}
		
		protected function initLayers() :void
		{
			model = new MapModel();
			
			mapLayer  = new MapLayer( model );
			
			var cellLayer:CellLayer = new CellLayer();
			var unitsLayer:UnitsLayer = new UnitsLayer( model );
			var tipsLayer:TipsLayer = new TipsLayer();
			
			this.push( mapLayer );
			this.push( cellLayer );
			this.push( unitsLayer );
			this.push( tipsLayer );
		}
		
		public function loadData() :void
		{
			model.loadData();
		}
	}
}