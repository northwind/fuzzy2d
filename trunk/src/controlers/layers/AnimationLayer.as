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
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class AnimationLayer extends BaseLayer
	{
		private var numberFormat:TextFormat = new TextFormat( null, "18px", null, true );
		
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
		
		public function showNumber( number:Number, color:uint, x:Number, y:Number, callback:Function = null ) : void
		{
			var filed:TextField = new TextField();
			filed.text = number.toString();
			filed.textColor = color;
			filed.defaultTextFormat = numberFormat;
			filed.mouseEnabled = false;
			
			filed.x = x;
			filed.y = y;
			
			this._view.addChild( filed );
			
			TweenLite.to( filed, 1, { y : y - 20, onComplete : function():void{
				_view.removeChild( filed );
				
				if ( callback != null )
					callback();
			} } );
		}
	}
}