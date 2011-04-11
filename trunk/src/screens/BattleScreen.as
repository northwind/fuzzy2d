package screens
{
	import com.norris.fuzzy.core.display.impl.ScrollScreen;
	
	import controlers.*;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	import models.impl.RecordModel;
	
	public class BattleScreen extends ScrollScreen
	{
		public var mapLayer:MapLayer;
		public var menuLayer:MenuLayer;
		public var model:RecordModel;
		
		public function BattleScreen(  model :RecordModel )
		{
			super();
			
			this._step = MyWorld.CELL_HEIGHT;
			
			this.model = model;
			
			if ( model.data != null )
				this.initLayers();
			else
				model.addEventListener( ModelEvent.COMPLETED, initLayers );
		}
		
		protected function initLayers( event:ModelEvent = null ) :void
		{
			var staticLayer:StaticLayer = new  StaticLayer( model.mapModel );
			var tileLayer:TileLayer = new TileLayer( model.mapModel );
			var unitsLayer:UnitsLayer = new UnitsLayer( model.mapModel );
			
			this.mapLayer  = new MapLayer( model.mapModel );
			var tipsLayer:TipsLayer = new TipsLayer();
			this.menuLayer = new MenuLayer();
			var debugLayer:DebugMsgLayer = new DebugMsgLayer();
			
			this._offsetTop = menuLayer.height;
			this.moveTo( model.mapModel.offsetX || 0, model.mapModel.offsetY || 0 );
			
			//需要卷屏
			this.pushToScroll( mapLayer );
			this.pushToScroll( tileLayer );
			this.pushToScroll( staticLayer );
			this.pushToScroll( unitsLayer );
			
			//固定区域
			this.push( tipsLayer );
			this.push( menuLayer );
			this.push( debugLayer );
		}
		
		public function loadData() :void
		{
			model.loadData();
		}
	}
}