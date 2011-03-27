package controlers
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
			
			this.view.x = model.background.oX || 0;
			this.view.y = model.background.oY || 0;
			
//			//添加默认色
//			this.view.graphics.beginFill( 0x333333 );
//			this.view.graphics.drawRect( 0, 0, model.cellXNum * MyWorld.CELL_WIDTH / 2, model.cellYNum * MyWorld.CELL_HEIGHT );
//			this.view.graphics.drawRect( 0, 0, -model.cellXNum * MyWorld.CELL_WIDTH / 2, model.cellYNum * MyWorld.CELL_HEIGHT );
//			this.view.graphics.endFill();
		}
		
	}
}