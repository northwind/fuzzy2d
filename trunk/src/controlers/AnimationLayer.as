package controlers
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
		[Embed(source='assets/circle_blue.png')]
		private var blueAsset:Class; 
		
		[Embed(source='assets/circle_red.png')]
		private var redAsset:Class;
		
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
			
			var blueBtn:Bitmap = new blueAsset() as Bitmap;
			var redBtn:Bitmap = new redAsset() as Bitmap;
			
			this.view.addChild( blueBtn );
			this.view.addChild( redBtn );
			
			TweenLite.to(blueBtn, 1, { x:100, y : 300 } );
			TweenLite.to(redBtn, 1, { x:200, y : 300 } );			
		}	
	}
}