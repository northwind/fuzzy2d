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
	
	public class ScrollScreen  extends Entity implements IScreen
	{
		private var _layers:Array = [];
		private var _view:Sprite = new Sprite();
		private var _name:String;
		
		public var fixedArea:Sprite = new Sprite();		//固定区域
		public var scrollArea:Sprite = new Sprite();      //可滚动区域
		
		protected var _step:uint = 32;								//滚动距离
		
		private var _totalHeight:Number = 0;
		private var _totalWidth:Number = 0;
		
		private var _mousedown:Boolean = false;
		private var _lastX:Number;
		private var _lastY:Number;
		private var _oriX:Number;
		private var _oriY:Number;
		private var _minWidth:Number;
		private var _minHeight:Number;
		
		public function ScrollScreen()
		{
			super();
			
			//固定区域在滚动区域之上
			_view.addChild( scrollArea );
			_view.addChild( fixedArea );
			
			this.addEventListener(Event.COMPLETE, onSetupComplete );
		}
		
		private function onSetupComplete( event:Event ) : void
		{
			if ( this._view.stage )	
				onAddStage();
			else	
				this._view.addEventListener(Event.ADDED_TO_STAGE, onAddStage );
		}
		
		protected function onAddStage( event:Event = null )  : void
		{
			this._view.removeEventListener(Event.ADDED_TO_STAGE, onAddStage );
			
			//滚动图像
			_totalWidth  = this.view.stage.stageWidth;
			_totalHeight = this.view.stage.stageHeight;
			
			//可完全显示，则退出
			if ( this._view.height <= _totalHeight && this._view.width <= _totalWidth )
				return;
			
			_minWidth = _totalWidth - this.view.width;
			_minHeight = _totalHeight - this.view.height;
			
			//滚动控制上下卷动
			if ( this.view.height > _totalHeight)
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
				move = Math.min( 0, _view.y + _step );
			}else{
				//滚轮向内 屏幕向上卷动				
				move = Math.max( _view.y - _step,  _totalHeight - _view.height  );
			}
			_view.y = move;
		}	
		
		private function onMouseDown( event:MouseEvent ) : void
		{
			_mousedown = true;
			
			_lastX = event.stageX;
			_lastY = event.stageY;
			
			_oriX = _view.x;
			_oriY = _view.y;
			
			//为了效率，直接继承onMouseMove
//			World.instance.inputMgr.on( InputKey.MOUSE_MOVE, onMouseMove );
			_view.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
			World.instance.inputMgr.on( InputKey.MOUSE_UP, onMouseUp );
			World.instance.inputMgr.on( InputKey.MOUSE_OUT, onMouseUp );
		}
		
		private function onMouseMove( event:MouseEvent ) : void
		{
			var diffX:Number = _oriX + event.stageX - _lastX;
			if ( diffX <= 0 && diffX >= _minWidth ){
				_view.x = diffX;
			}
			
			var diffY:Number = _oriY + event.stageY - _lastY;
			if ( diffY <= 0 && diffY >= _minHeight ){
				_view.y = diffY;
			}
		}
		
		private function onMouseUp( event:MouseEvent ) : void
		{
			_mousedown = false;
			
			//World.instance.inputMgr.un( InputKey.MOUSE_MOVE, onMouseMove );
			_view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove );
			World.instance.inputMgr.un( InputKey.MOUSE_UP, onMouseUp );
			World.instance.inputMgr.un( InputKey.MOUSE_OUT, onMouseUp );
		}
		
		public function set name( value:String ) : void
		{
			_name = value;
		}
		
		public function get name() : String
		{
			return _name;
		}
		
		/**
		 *  默认添加到固定区域中 
		 * @param layer
		 * 
		 */		
		public function push(layer:ILayer):void
		{
			_layers.push( layer );
			
			//如果没有view强制指定
			if ( layer.view == null )
				layer.view = new Sprite();
			
			fixedArea.addChild( layer.view );
			
			//自动添加component
			if ( layer is IComponent )
				this.addComponent( layer );			
		}
		
		/**
		 *  添加到滚动区域中 
		 * @param layer
		 * 
		 */		
		public function pushToScroll(layer:ILayer):void
		{
			_layers.push( layer );
			
			//如果没有view强制指定
			if ( layer.view == null )
				layer.view = new Sprite();
			
			scrollArea.addChild( layer.view );
			
			//自动添加component
			if ( layer is IComponent )
				this.addComponent( layer );			
		}
		
		public function get(pri:uint):ILayer
		{
			if ( pri >= this._layers.length )
				return null;
			
			return this._layers[ pri ] as ILayer;
		}
		
		public function get count():uint
		{
			return this._layers.length;
		}
		
		public function get view():Sprite
		{
			return _view;
		}
	}
}