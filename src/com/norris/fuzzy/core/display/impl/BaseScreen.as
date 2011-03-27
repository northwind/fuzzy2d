package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.World;
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.impl.Entity;
	import com.norris.fuzzy.core.display.ILayer;
	import com.norris.fuzzy.core.display.IScreen;
	import com.norris.fuzzy.core.input.impl.InputKey;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 按序添加layer 最后加优先级最高,倒序显示
	 * @author norris
	 * 
	 */	
	public class BaseScreen extends Entity implements IScreen
	{
		private var _layers:Array = [];
		private var _view:Sprite = new Sprite();
		private var _name:String;
		
		protected var _step:uint = 32;
		private var _totalHeight:Number = 0;
		private var _totalWidth:Number = 0;
		
		public function BaseScreen()
		{
			super();
			
			this._view.addEventListener(Event.ADDED_TO_STAGE, onAddStage );
		}
		
		protected function onAddStage( event:Event = null )  : void
		{
			this._view.removeEventListener(Event.ADDED_TO_STAGE, onAddStage );
			
			//滚动图像
			_totalWidth  = this.view.stage.stageWidth;
			_totalHeight = this.view.stage.stageHeight;
			
			//可完全显示，则退出
			if ( this.view.height <= _totalHeight && this.view.width <= _totalWidth )
				return;
			
			_minWidth = _totalWidth - this.view.width;
			_minHeight = _totalHeight - this.view.height;
			
			//滚动控制上下卷动
			if ( this.view.height > _totalHeight)
				World.instance.inputMgr.on(InputKey.MOUSE_WHEEL, onMouseWheel );
			
			//鼠标拖动控制整体卷动
			World.instance.inputMgr.on( InputKey.MOUSE_LEFT, onMouseDown );			
		}
		
		private var _mousedown:Boolean = false;
		private var _lastX:Number;
		private var _lastY:Number;
		private var _oriX:Number;
		private var _oriY:Number;
		private var _minWidth:Number;
		private var _minHeight:Number;
		
		private function onMouseDown( event:MouseEvent ) : void
		{
			_mousedown = true;
			
			_lastX = event.stageX;
			_lastY = event.stageY;
			
			_oriX = this._view.x;
			_oriY = this._view.y;
			
			World.instance.inputMgr.on( InputKey.MOUSE_MOVE, onMouseMove );
			World.instance.inputMgr.on( InputKey.MOUSE_UP, onMouseUp );
		}
		
		private function onMouseMove( event:MouseEvent ) : void
		{
			var diffX:Number = _oriX + event.stageX - _lastX;
			if ( diffX <= 0 && diffX >= _minWidth ){
				this._view.x = diffX;
			}
			
			var diffY:Number = _oriY + event.stageY - _lastY;
			if ( diffY <= 0 && diffY >= _minHeight ){
				this._view.y = diffY;
			}
		}
		
		private function onMouseUp( event:MouseEvent ) : void
		{
			_mousedown = false;
			
			World.instance.inputMgr.un( InputKey.MOUSE_MOVE, onMouseMove );
			World.instance.inputMgr.un( InputKey.MOUSE_UP, onMouseUp );
		}
		
		private function onMouseWheel( event:MouseEvent ) : void
		{
			var move:int;
			if ( event.delta > 0 ){
				//滚轮向外 屏幕向下卷动	
				move = Math.min( 0, this.view.y + _step );
			}else{
				//滚轮向内 屏幕向上卷动				
				move = Math.max( this.view.y - _step,  _totalHeight - this.view.height  );
			}
			this.view.y = move;
		}		
		public function set name( value:String ) : void
		{
			_name = value;
		}
		
		public function get name() : String
		{
			return _name;
		}
		
		public function push( layer:ILayer ):void
		{
			_layers.push( layer );
			
			//如果没有view强制指定
			if ( layer.view == null )
				layer.view = new Sprite();
					
			_view.addChild( layer.view );
			
			//自动添加component
			if ( layer is IComponent )
				this.addComponent( layer );
		}
		
		public function remove(pri:uint):void
		{
			if ( pri >=  this._layers.length )
				return;
			
			var tmp:ILayer = this.get( pri );
			if ( tmp == null )
				return;
			
			//先从数组中删除
			this._layers.splice( pri, 1 );
			
			try{
				//_view.removeChild( tmp.view );				
				_view.removeChildAt( pri );
			}catch( e:Error ){
				Logger.error( "BaseScreen remove error : pri = " + pri );
			}
		}
		
		public function get(pri:uint):ILayer
		{
			if ( pri >= this._layers.length )
				return null;
			
			return this._layers[ pri ] as ILayer;
		}

		public function get count() : uint
		{
			return this._layers.length;
		}
		
		public function get view() : Sprite
		{
			return _view as Sprite;
		}
		
		/**
		 *  覆盖setup，完成移动屏幕的操作
		 */		
		override public function setup():void
		{
			super.setup();
		}
		
	}
}