package controlers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import com.norris.fuzzy.core.display.impl.SWFLayer;
	import com.norris.fuzzy.core.resource.impl.SWFResource;
	
	import flash.events.Event;
	
	public class MenuLayer extends SWFLayer
	{
		public function MenuLayer()
		{
			super( "NavBar" );
		}
		
		override protected function onStage( event:Event = null ) :void
		{
			super.onStage( event );
			
			movieClip.cacheAsBitmap = true;
			movieClip.y = 3;
			movieClip.x = ( this.view.stage.stageWidth - movieClip.width ) / 2;
			
			this.view.graphics.beginFill( 0xCCCCCC );
			this.view.graphics.drawRect( 0, 0, this.view.stage.stageWidth, 30 );
			this.view.graphics.endFill();
			
		}
	}
}