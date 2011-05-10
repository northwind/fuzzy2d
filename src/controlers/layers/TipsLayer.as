package controlers.layers
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.motionPaths.*;
	import com.norris.fuzzy.core.display.impl.BaseLayer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
	 *  提示框
	 * @author norris
	 * 
	 */	
	public class TipsLayer extends BaseLayer
	{
		public var menuLayer:MenuLayer;
		
		private var top:TextField = new TextField();
		private var topWrap:Sprite = new Sprite();
		private var topTween:TweenLite;
		private var topTimer:Timer = new Timer( 4000, 1 );
		
		private var bottom:TextField = new TextField();
		private var bottomWrap:Sprite = new Sprite();
		private var bottomTween:TweenLite;
		private var bottomTimer:Timer = new Timer( 1000, 1 );		//延迟显示
		private var bottomContent:String;											//保存起来
		
		public function TipsLayer()
		{
			super();
			
			top.mouseEnabled = false;
			top.mouseWheelEnabled = false;
			top.tabEnabled = false;
			top.textColor = 0xffffff;
			top.wordWrap = false;
			topWrap.addChild( top );
			this._view.addChild( topWrap ); 
			
			bottom.mouseEnabled = false;
			bottom.mouseWheelEnabled = false;
			bottom.tabEnabled = false;
			bottom.multiline = true;
			bottom.textColor = 0xffffff;
			bottomWrap.addChild( bottom );
			this._view.addChild( bottomWrap );
			
			topTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTopTimerCompleted );
			bottomTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onBottomCompleted );
		}
		
		public function topTip( content:String ) :void
		{
			if ( topTween != null ){
				topTween.kill();
			}
			if ( topTimer.running )
				topTimer.stop();
			
			top.text = content;
			topWrap.visible = true;
			
			var textWidth:Number = top.textWidth + 10; 
			var wrapWidth:Number = Math.max( 200, textWidth + 30 );
			
			top.width = textWidth;
			top.y = 5;
			topWrap.alpha = 0;
			topWrap.y = 20;
			
			topWrap.graphics.clear();
			topWrap.graphics.beginFill( 0x0000ff, 0.5 );
			topWrap.graphics.drawRoundRect( 0, 0, wrapWidth, 30, 8, 8 );
			topWrap.graphics.endFill();
			
			top.x = (wrapWidth - textWidth ) /2 ;
			topWrap.x = ( this._view.stage.stageWidth - wrapWidth ) / 2;
			
			topTween = TweenLite.to( topWrap, 0.7, { y : 33, alpha : 1 } );
			
			topTimer.reset();
			topTimer.start();
		}
		
		protected function onTopTimerCompleted(event:Event):void
		{
			top.text = "";
			topWrap.visible = false;
		}
		
		/**
		 * TODO 考虑文字很多换行 
		 * @param content
		 * 
		 */		
		public function showBottomTip ( content:String ) :void
		{
			if ( content.length == 0  )
				return;
			//先隐藏
			if ( bottomTimer.running ){
				hideBottomTip();
			}
			if ( bottomTween != null ){
				bottomTween.kill();
			}
			
			bottomContent = content;
			
			bottomTimer.reset();
			bottomTimer.start();
		}
		
		public function hideBottomTip():void
		{
			bottomWrap.visible = false;
			bottomContent = null;
			
			if ( bottomTimer.running )
				bottomTimer.stop();
		}
		
		protected function onBottomCompleted(event:Event):void
		{
			bottom.text = bottomContent;
			bottomWrap.visible = true;
			
			var textWidth:Number = bottom.textWidth + 10; 
			var wrapWidth:Number = Math.max( 200, textWidth );
			
			bottom.y = 5;
			bottom.x = 20;
			
			bottomWrap.alpha = 0.3;
			bottomWrap.x = -8;
			bottomWrap.y = this._view.stage.stageHeight - 30;
			
			bottomWrap.graphics.clear();
			bottomWrap.graphics.beginFill( 0x0000ff, 0.5 );
			bottomWrap.graphics.drawRoundRect( 0, 0, wrapWidth, 30, 8, 8 );
			bottomWrap.graphics.endFill();
			
			bottomTween = TweenLite.to( bottomWrap, 0.5, { alpha : 1 } );			
		}
	}
}