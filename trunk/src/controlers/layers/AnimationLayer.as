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
		
		public function playMovie( mc:MovieClip, x:Number, y:Number, callback:Function = null ) :void
		{
			//播放结束后移除
			mc.addFrameScript( mc.totalFrames-1, function() :void {
				mc.stop();
				_view.removeChild( mc );
				if ( callback != null )
					callback();
			});
			
			mc.x = x;
			mc.y = y;
			this._view.addChild( mc );
		}
	}
}