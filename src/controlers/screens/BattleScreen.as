package controlers.screens
{
	import com.norris.fuzzy.core.display.impl.BaseScreen;
	import com.norris.fuzzy.core.display.impl.ScrollLayerContainer;
	import com.norris.fuzzy.core.display.impl.ScrollScreen;
	
	import controlers.layers.*;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	import models.impl.RecordModel;
	
	public class BattleScreen extends BaseScreen
	{
		public var mapLayer:MapLayer;
		public var menuLayer:MenuLayer;
		public var model:RecordModel;
		
		public function BattleScreen(  model :RecordModel )
		{
			this.model = model;

			super();
			
			if ( model.data != null )
				this.onModelCompleted();
			else
				model.addEventListener( ModelEvent.COMPLETED, onModelCompleted );
		}
		
		protected function onModelCompleted( event:ModelEvent = null ) :void
		{
			var staticLayer:StaticLayer = new  StaticLayer( model.mapModel );
			var tileLayer:TileLayer = new TileLayer( model.mapModel );
			var unitsLayer:UnitsLayer = new UnitsLayer( model );
			var actionLayer:ActionLayer = new ActionLayer();
			var cancelLayer:CancelLayer = new CancelLayer();
			
			this.mapLayer  = new MapLayer( model.mapModel );
			var tipsLayer:TipsLayer = new TipsLayer();
			this.menuLayer = new MenuLayer();
			var debugLayer:DebugMsgLayer = new DebugMsgLayer();
			var animationLayer:AnimationLayer = new AnimationLayer();
			
			//需要卷屏
			var scrollLayer:ScrollLayerContainer = new ScrollLayerContainer();
			scrollLayer.push( mapLayer );
			scrollLayer.push( tileLayer );
			scrollLayer.push( staticLayer );
			scrollLayer.push( unitsLayer );
			scrollLayer.push( actionLayer );
			scrollLayer.push( animationLayer );
			scrollLayer.view.y = menuLayer.height;
			//scrollLayer.clip = new Rectangle( 0, -menuLayer.height, model.mapModel.totalWidth, model.mapModel.totalHeight + menuLayer.height );  
			scrollLayer.step = MyWorld.CELL_HEIGHT;
			scrollLayer.scrollTo( model.mapModel.offsetX || 0, model.mapModel.offsetY || 0 );
			
			//按深度添加
			this.push( scrollLayer );
			this.push( cancelLayer );
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