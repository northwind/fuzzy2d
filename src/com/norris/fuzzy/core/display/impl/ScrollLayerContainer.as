package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.World;
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.impl.Entity;
	import com.norris.fuzzy.core.display.ILayer;
	import com.norris.fuzzy.core.display.ILayerContainer;
	import com.norris.fuzzy.core.display.IScreen;
	import com.norris.fuzzy.core.input.impl.InputKey;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ScrollLayerContainer extends BaseLayerContainer implements ILayerContainer
	{
		public var step:uint = 32;								//滚动距离
		
		protected var _totalHeight:Number;			//screen总高度
		protected var _totalWidth:Number;				//screen总宽度
		
		private var _mousedown:Boolean = false;
		private var _mousemove:Boolean = false;
		private var _lastX:Number;					//鼠标点击时X
		private var _lastY:Number;					//鼠标点击时Y
		private var _maxWidth:Number;				//可滚动的最大值
		private var _maxHeight:Number;				//可滚动的最大值
		private var _oriRect:Rectangle;				//初始化时的显示范围
		private var _rect:Rectangle;				//控制scrollArea显示区域
		private var _scrollX:int;					//缓存起来的滚动位置
		private var _scrollY:int;					//缓存起来的滚动位置
		
		public function ScrollLayerContainer()
		{
			super();
			
			this.addEventListener(Event.COMPLETE, onSetupComplete );
		}
		
		private function onSetupComplete( event:Event ) : void
		{
			this.removeEventListener(Event.COMPLETE, onSetupComplete );
			
			if ( this._view.stage )	
				onAddStage();
			else	
				this._view.addEventListener(Event.ADDED_TO_STAGE, onAddStage );
		}
		
		protected function onAddStage( event:Event = null )  : void
		{
			this._view.removeEventListener(Event.ADDED_TO_STAGE, onAddStage );
			
			//滚动图像
			_totalWidth  = Math.min( this._view.stage.stageWidth, this._view.parent.width );
			_totalHeight = Math.min( this._view.stage.stageHeight, this._view.parent.height );
			
			//可完全显示，则退出
			if ( this._view.height <= _totalHeight && this._view.width <= _totalWidth )
				return;
			
			//设置显示范围
			if ( this._view.scrollRect == null ){
				this._view.scrollRect = new Rectangle( 0, 0, _totalWidth, _totalHeight );
			}
			_oriRect = this._view.scrollRect.clone();
			_rect = this._view.scrollRect.clone();
			
			_maxWidth = this._view.width - _totalWidth + _oriRect.x;
			_maxHeight = this._view.height - _totalHeight + _oriRect.y;		//计算Y可移动的最大值
			
			//滚动控制上下卷动
			if ( this._view.height > _totalHeight)
				World.instance.inputMgr.on(InputKey.MOUSE_WHEEL, onMouseWheel );
			
			//鼠标拖动控制整体卷动
			World.instance.inputMgr.on( InputKey.MOUSE_LEFT, onMouseDown );		
			
			//延迟滚动到指定位置
			this.scrollTo( _scrollX, _scrollY );
		}
		
		private function onMouseWheel( event:MouseEvent ) : void
		{
			//按住左键时忽略滚轮
			if ( _mousedown )
				return;
			
			var move:int;
			if ( event.delta > 0 ){
				//滚轮向外 屏幕向下卷动	
				move = Math.max( _oriRect.y , _rect.y - step );
			}else{
				//滚轮向内 屏幕向上卷动				
				move = Math.min( _maxHeight, _rect.y + step );
			}
			if ( move != _rect.y ){
				_rect.y = move;
				this._view.scrollRect = _rect;
			}
		}	
		
		private function onMouseDown( event:MouseEvent ) : void
		{
			_mousedown = true;
			_mousemove = false;
			
			_lastX = event.stageX;
			_lastY = event.stageY;
			
			//为了效率，直接继承onMouseMove
			//			World.instance.inputMgr.on( InputKey.MOUSE_MOVE, onMouseMove );
			this._view.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
			World.instance.inputMgr.on( InputKey.MOUSE_UP, onMouseUp );
			World.instance.inputMgr.on( InputKey.MOUSE_OUT, onMouseUp );
		}
		
		private function onMouseMove( event:MouseEvent ) : void
		{
			var diffX:Number = _rect.x - ( event.stageX - _lastX );
			if ( diffX >= _oriRect.x && diffX <= _maxWidth ){
				_mousemove = true;
				_rect.x = diffX;
			}
			_lastX = event.stageX;
			
			var diffY:Number = _rect.y - ( event.stageY - _lastY );
			if ( diffY >= _oriRect.y && diffY <= _maxHeight ){
				_mousemove = true;
				_rect.y = diffY;
			}
			_lastY = event.stageY;
			
			this._view.scrollRect = _rect;
		}
		
		private function onMouseUp( event:MouseEvent ) : void
		{
			if ( _mousemove )
				event.stopPropagation();
				
			_mousedown = false;
			
			//World.instance.inputMgr.un( InputKey.MOUSE_MOVE, onMouseMove );
			this._view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
			World.instance.inputMgr.un( InputKey.MOUSE_UP, onMouseUp );
			World.instance.inputMgr.un( InputKey.MOUSE_OUT, onMouseUp );
		}
		
		public function scrollTo( x:int, y:int ) : void
		{
			//未添加到显示列表前，把滚动的参数缓存起来
			if ( this._view.stage == null ){
				this._scrollX = x;
				this._scrollY = y;
			}else{
				if ( x >= _oriRect.x && x <= _maxWidth ){
					_rect.x = x;
				}
				if ( y >= _oriRect.y && y <= _maxHeight ){
					_rect.y = y;
				}
				
				this._view.scrollRect = _rect;
			}
		}
		
		/**
		 * 转化为屏幕中的位置 
		 * @param point
		 * 
		 */		
		public function toScreen( point:Point ) : void
		{
			point.x = point.x - _rect.x + this.view.x;
			point.y = point.y - _rect.y + this.view.y;
		}
		
	}
}