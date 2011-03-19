package screens
{
	import com.norris.fuzzy.core.display.impl.BaseScreen;
	
	import controlers.*;
	
	import models.impl.MapModel;
	
	public class BattleScreen extends BaseScreen
	{
		public var mapLayer:MapLayer;
		public var mapModel:MapModel;
		
		public function BattleScreen( map:MapModel )
		{
			super();
			
			this.mapModel = map;
			
			this.initLayers();
		}
		
		protected function initLayers() :void
		{
			mapLayer  = new MapLayer( mapModel );
			
			var cellLayer:CellLayer = new CellLayer();
			var unitsLayer:UnitsLayer = new UnitsLayer( mapModel );
			var tipsLayer:TipsLayer = new TipsLayer();
			
			this.push( mapLayer );
			this.push( cellLayer );
			this.push( unitsLayer );
			this.push( tipsLayer );
		}
		
		public function loadData() :void
		{
			mapModel.loadData();
		}
	}
}