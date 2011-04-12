package
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.motionPaths.*;
	
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.events.Event;
	import flash.geom.*;
	
	public class TestTween extends Sprite
	{
		[Embed(source='assets/circle_blue.png')]
		private var blueAsset:Class; 
		
		[Embed(source='assets/circle_red.png')]
		private var redAsset:Class; 
		
		public function TestTween()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);		
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			if ( this.stage )
			{
				this.stage.scaleMode = StageScaleMode.NO_SCALE;
				this.stage.align = StageAlign.TOP_LEFT;
			}
			
			
			var blue:Bitmap = new blueAsset() as Bitmap;
			var blueBtn:IconButton = new IconButton( blue.bitmapData, "I'm blue" );
			var redBtn:IconButton = new IconButton( (new redAsset() as Bitmap).bitmapData, "I'm red" );
			
			this.addChild( blueBtn );
			this.addChild( redBtn );
			
			TweenLite.to(blueBtn, 1, { x:100, y : 100 } );
			TweenLite.to(redBtn, 1, { x:200, y : 100 } );
			
		}
		
	}
}