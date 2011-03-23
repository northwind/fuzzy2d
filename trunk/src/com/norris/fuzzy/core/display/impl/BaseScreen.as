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
		private var _maxHeight:uint = 0;
		private var _maxWidth:uint = 0;
		
		public function BaseScreen()
		{
			super();
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
			
			//滚动图像
			_maxWidth  = World.instance.area.width;
			_maxHeight = World.instance.area.height;
			
			//可完全显示，则退出
			if ( this.view.height <= _maxHeight && this.view.width <= _maxWidth )
				return;
			
			//滚动控制上下卷动
			if ( this.view.height > _maxHeight)
				World.instance.inputMgr.on(InputKey.MOUSE_WHEEL, onMouseWheel );
			
			//鼠标拖动控制整体卷动
//			World.instance.inputMgr.
		}
		
		private function onMouseWheel( event:MouseEvent ) : void
		{
			var move:int;
			if ( event.delta > 0 ){
				//滚轮向外 屏幕向下卷动	
//				move = Math.min( this.view.y + _step,  0  );
				move = this.view.y + _step;
			}else{
				//滚轮向内 屏幕向上卷动				
				move = Math.max( this.view.y - _step,  _maxHeight - this.view.height  );
			}
			this.view.y = move;
		}
		
	}
}