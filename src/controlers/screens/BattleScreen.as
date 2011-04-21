package controlers.screens
{
	import com.norris.fuzzy.core.display.impl.ScrollScreen;
	
	import controlers.layers.*;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
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
			this._step = MyWorld.CELL_HEIGHT;
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
			
			this.mapLayer  = new MapLayer( model.mapModel );
			var tipsLayer:TipsLayer = new TipsLayer();
			this.menuLayer = new MenuLayer();
			var debugLayer:DebugMsgLayer = new DebugMsgLayer();
			var animationLayer:AnimationLayer = new AnimationLayer();
			
			this.moveTo( model.mapModel.offsetX || 0, model.mapModel.offsetY || 0 );
			
			//需要卷屏
			this.pushToScroll( mapLayer );
			this.pushToScroll( tileLayer );
			this.pushToScroll( staticLayer );
			this.pushToScroll( unitsLayer );
			this.pushToScroll( actionLayer );
			this.pushToScroll( animationLayer );
			
			//固定区域
			this.push( tipsLayer );
			this.push( menuLayer );
			this.push( debugLayer );
			
			this.scrollArea.y = menuLayer.height;
			//限制滚动区域可显示大小
//			this.scrollArea.scrollRect = new Rectangle( 0, -menuLayer.height, 
//									model.mapModel.totalWidth, model.mapModel.totalHeight + menuLayer.height );
//			//hack 让scrollArea的宽高立即生效
//			var bmpData:BitmapData = new BitmapData(1, 1);
//			bmpData.draw( this.scrollArea );
		}
		
		public function loadData() :void
		{
			model.loadData();
		}
	}
}