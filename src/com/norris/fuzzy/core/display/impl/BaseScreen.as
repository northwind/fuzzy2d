package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.impl.Entity;
	import com.norris.fuzzy.core.display.ILayer;
	import com.norris.fuzzy.core.display.ILayerContainer;
	import com.norris.fuzzy.core.display.IScreen;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * 按序添加layer 最后加优先级最高,倒序显示
	 * @author norris
	 * 
	 */	
	public class BaseScreen extends Entity implements IScreen
	{
		protected var _layers:Array = [];
		protected var _view:Sprite = new Sprite();
		private var _name:String;
		
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
			
			try
			{
				_view.addChild( layer.view );
			}
			catch(error:Error) 
			{
				Logger.error( "Screen : " + this._name + " add layer " + _layers.length + " view error." );
			}
			
			//自动添加component  先添加子元素
			if ( layer is ILayerContainer ){
				for each (var l:ILayer in ( layer as ILayerContainer ).layers ) {
					this.addComponent( l );
				}
			}
			
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
	}
}