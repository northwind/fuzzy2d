package controlers.layers
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.motionPaths.*;
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class AnimationLayer extends BaseLayer
	{
		public function AnimationLayer()
		{
			super();
		}
		
		public function playMovie( mc:MovieClip, x:Number, y:Number, callback:Function ) :void
		{
			mc.addEventListener(Event.EXIT_FRAME, onExitFrame );			
				
			mc.x = x;
			mc.y = y;
			this._view.addChild( mc );
		}
		
		protected function onExitFrame(event:Event):void
		{
			if ( this._view.numChildren == 0 )
				return;
			trace(  "onExitFrame" );
			try
			{
				this._view.removeChild( event.target as DisplayObject );	
			} 
			catch(error:Error) 
			{
				
			}
			
		}
		
	}
}