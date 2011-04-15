package controlers.layers
{
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.motionPaths.*;
	
	public class AnimationLayer extends BaseLayer
	{
		public function AnimationLayer()
		{
			super();
			
			if ( this.view.stage )
				onStage();
			else
				this.view.addEventListener(Event.ADDED_TO_STAGE, onStage );
		}
		
		protected function onStage( event:Event = null ) :void
		{
			this.view.removeEventListener(Event.ADDED_TO_STAGE, onStage );
		}	
	}
}