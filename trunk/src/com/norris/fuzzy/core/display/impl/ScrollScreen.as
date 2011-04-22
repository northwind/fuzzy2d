package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.World;
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.impl.Entity;
	import com.norris.fuzzy.core.display.ILayer;
	import com.norris.fuzzy.core.display.IScreen;
	import com.norris.fuzzy.core.input.impl.InputKey;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * 废弃采用layerContainer
	 * 分为静止和滚动两个层 
	 * 可对scrollArea设置scrollRect限制其大小和显示范围 
	 * @author norris
	 * 
	 */	
	public class ScrollScreen  extends BaseScreen implements IScreen
	{
//		public var fixedArea:Sprite = new Sprite();		//固定区域
		public var scrollArea:Sprite = new Sprite();      //可滚动区域
		
		protected var _step:uint = 32;								//滚动距离
		
		protected var _totalHeight:Number;			//screen总高度
		protected var _totalWidth:Number;				//screen总宽度
		
		private var _mousedown:Boolean = false;
		private var _lastX:Number;
		private var _lastY:Number;
		private var _oriX:Number;
		private var _oriY:Number;
		private var _maxWidth:Number;
		private var _maxHeight:Number;
		private var _oriRect:Rectangle;
		private var _rect:Rectangle;				//控制scrollArea显示区域
		
		public function ScrollScreen()
		{
			super();
			
			//固定区域在滚动区域之上
			_view.addChild( scrollArea );
//			_view.addChild( fixedArea );
				
			this.addEventListener(Event.COMPLETE, onSetupComplete );
		}
		
		private function onSetupComplete( event:Event ) : void
		{
			if ( scrollArea.stage )	
				onAddStage();
			else	
				scrollArea.addEventListener(Event.ADDED_TO_STAGE, onAddStage );
		}
		
		protected function onAddStage( event:Event = null )  : void
		{
			scrollArea.removeEventListener(Event.ADDED_TO_STAGE, onAddStage );
			
			//滚动图像
			_totalWidth  = scrollArea.stage.stageWidth;
			_totalHeight = scrollArea.stage.stageHeight;
			
			//可完全显示，则退出
			if ( scrollArea.height <= _totalHeight && scrollArea.width <= _totalWidth )
				return;
			
			//设置scrollArea显示区域
//			if ( this.scrollArea.scrollRect == null )
//				this.scrollArea.scrollRect = new Rectangle( 0, 0, _totalWidth, _totalHeight );
//			_oriRect = this.scrollArea.scrollRect
			
			_maxWidth = _totalWidth - scrollArea.width;
			_maxHeight = _totalHeight - scrollArea.height;
			
			//滚动控制上下卷动
			if ( scrollArea.height > _totalHeight)
				World.instance.inputMgr.on(InputKey.MOUSE_WHEEL, onMouseWheel );
			
			//鼠标拖动控制整体卷动
			World.instance.inputMgr.on( InputKey.MOUSE_LEFT, onMouseDown );			
		}
		
		private function onMouseWheel( event:MouseEvent ) : void
		{
			//按住左键时忽略滚轮
			if ( _mousedown )
				return;
			
			var move:int;
			if ( event.delta > 0 ){
				//滚轮向外 屏幕向下卷动	
				move = Math.min( 0, scrollArea.y + _step );
			}else{
				//滚轮向内 屏幕向上卷动				
				move = Math.max( scrollArea.y - _step,  _totalHeight - scrollArea.height  );
			}
			
//			_rect = scrollArea.scrollRect;
//			_rect.y = move;
//			scrollArea.scrollRect = _rect;
			scrollArea.y = move;
		}	
		
		private function onMouseDown( event:MouseEvent ) : void
		{
			_mousedown = true;
			
			_lastX = event.stageX;
			_lastY = event.stageY;
			
			_oriX = scrollArea.x;
			_oriY = scrollArea.y;
			
			//为了效率，直接继承onMouseMove
//			World.instance.inputMgr.on( InputKey.MOUSE_MOVE, onMouseMove );
			scrollArea.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
			World.instance.inputMgr.on( InputKey.MOUSE_UP, onMouseUp );
			World.instance.inputMgr.on( InputKey.MOUSE_OUT, onMouseUp );
		}
		
		private function onMouseMove( event:MouseEvent ) : void
		{
			var diffX:Number = _oriX + event.stageX - _lastX;
			if ( diffX <= 0 && diffX >= _maxWidth ){
				scrollArea.x = diffX;
			}
			
			var diffY:Number = _oriY + event.stageY - _lastY;
			if ( diffY <= 0 && diffY >= _maxHeight ){
				scrollArea.y = diffY;
			}
		}
		
		public function moveTo( x:Number, y:Number ) :void
		{
			scrollArea.x = x;
			scrollArea.y = Math.min( 0, y );
		}
		
		private function onMouseUp( event:MouseEvent ) : void
		{
			_mousedown = false;
			
			//World.instance.inputMgr.un( InputKey.MOUSE_MOVE, onMouseMove );
			scrollArea.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
			World.instance.inputMgr.un( InputKey.MOUSE_UP, onMouseUp );
			World.instance.inputMgr.un( InputKey.MOUSE_OUT, onMouseUp );
		}
		
		/**
		 *  添加到滚动区域中 
		 * @param layer
		 * 
		 */		
		public function pushToScroll(layer:ILayer):void
		{
			_layers.push( layer );
			
			scrollArea.addChild( layer.view );
			
			//自动添加component
			if ( layer is IComponent )
				this.addComponent( layer );			
		}
	}
}