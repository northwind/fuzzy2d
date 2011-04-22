package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.display.ILayer;
	import com.norris.fuzzy.core.display.ILayerContainer;
	
	import flash.geom.Rectangle;
	
	public class BaseLayerContainer extends BaseLayer implements ILayerContainer
	{
		private var _items:Array = [];
		
		public function BaseLayerContainer()
		{
			super();
		}
		
		public function push(layer:ILayer):void
		{
			_items.push( layer );
			
			this._view.addChild( layer.view );
		}
		
		public function get layers():Array
		{
			return _items;
		}
		
		public function set clip( value:Rectangle ) :void
		{
			this._view.scrollRect = value;
		}
		
		public function get clip() :Rectangle
		{
			return this._view.scrollRect;
		}
	}
}