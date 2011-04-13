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
	
	import views.*;
	
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
			
			animate();
		}
		
		private function animate() : void
		{
			var blue:Bitmap = new blueAsset() as Bitmap;
			var blueBtn:BlowIconButton = new BlowIconButton( blue.bitmapData, "I'm blue" );
			var redBtn:IconButton = new IconButton( (new redAsset() as Bitmap).bitmapData, "I'm red" );
			
			this.addChild( blueBtn );
			this.addChild( redBtn );

			runTo( blueBtn, 90 * Math.PI/180 );
			runTo( redBtn, -90 * Math.PI/180 );
			
			blueBtn.addEventListener(MouseEvent.CLICK, onClick );
			
		}
		
		private function onClick( event:Event ):void
		{
			trace( "onClick" );
		}
		
		private var r:Number = 150;
		private var oX:Number = 200;
		private var oY:Number = 200;
		private var oScale:Number = 0.1;
		private var oAlpha:Number = 0.5;
		
		private function runTo( target:DisplayObject, angle:Number ) : void
		{
			target.x = oX;
			target.y = oY;
			target.scaleX = oScale;
			target.scaleY = oScale;
			target.alpha = oAlpha;
			
			var x:int = oX + r * Math.cos( angle  );
			var y:int = oY - r * Math.sin( angle );
			
			TweenLite.to(target, 0.7, { x:x, y : y, scaleX : 1, scaleY : 1, alpha: 1 } );
		}
		
	}
}