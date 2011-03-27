package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.log.Logger;
	import flash.events.Event;
	
	public class CentreScreen extends BaseScreen
	{
		public function CentreScreen()
		{
			super();
		}
		
		override protected function onAddStage( event:Event = null )  : void
		{
			super.onAddStage( event );
			
			this.view.x = ( this.view.stage.stageWidth - this.view.width ) / 2;
			this.view.y = ( this.view.stage.stageHeight - this.view.height ) / 2;
			
		}
		
	}
}