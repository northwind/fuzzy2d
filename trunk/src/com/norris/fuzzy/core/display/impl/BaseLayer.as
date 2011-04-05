package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.core.display.ILayer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class BaseLayer extends BaseComponent implements ILayer
	{
		private var _pri:uint;
		private var _view:Sprite = new Sprite();
		
		public function BaseLayer()
		{
			super();
		}
		
//		public function set pri(value:uint):void
//		{
//			this._pri = value;
//		}
//		
//		public function get pri():uint
//		{
//			return this._pri;
//		}
		
		public function get view() :Sprite
		{
			return _view;
		}
		
//		public function set view( value:Sprite ) :void
//		{
//			_view = value;
//		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			if ( _view != null )
				_view = null;
		}
		
	}
}