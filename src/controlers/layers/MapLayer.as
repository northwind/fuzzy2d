package controlers.layers
{
	import com.norris.fuzzy.core.display.impl.ImageLayer;
	import com.norris.fuzzy.core.input.impl.InputKey;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.resource.impl.ImageResource;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	
	public class MapLayer extends ImageLayer
	{
		public var model:MapModel;
		
		public function MapLayer( model:MapModel )
		{
			super();
			
			this.model = model;

			//添加背景色
			if ( model.background.color != undefined ){
				this.view.graphics.beginFill( model.background.color as uint );
				this.view.graphics.drawRect( 0, 0, model.cellXNum * MyWorld.CELL_WIDTH, model.cellYNum * MyWorld.CELL_HEIGHT );
				this.view.graphics.endFill();
			}
		}
		
	}
}