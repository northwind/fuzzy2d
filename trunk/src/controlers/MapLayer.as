package controlers
{
	import com.norris.fuzzy.core.display.impl.ImageLayer;
	import com.norris.fuzzy.core.resource.impl.ImageResource;
	
	import models.event.ModelEvent;
	import models.impl.MapModel;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class MapLayer extends ImageLayer
	{
		public var model:MapModel;
		
		public function MapLayer( model:MapModel )
		{
			super();
			
			this.model = model;
			
			this.view.x = model.background.oX;
			this.view.y = model.background.oY;
			
			//添加默认色
			this.view.graphics.beginFill( 0x333333 );
			this.view.graphics.drawRect( 0, 0, model.cellXNum * MyWorld.CELL_WIDTH / 2, model.cellYNum * MyWorld.CELL_HEIGHT );
			this.view.graphics.drawRect( 0, 0, -model.cellXNum * MyWorld.CELL_WIDTH / 2, model.cellYNum * MyWorld.CELL_HEIGHT );
			this.view.graphics.endFill();
		}
	}
}