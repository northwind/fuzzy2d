package com.norris.fuzzy.map.item
{
	import com.norris.fuzzy.map.IMapItem;
	
	import flash.display.DisplayObject;
	
	public class BaseMapItem implements IMapItem
	{
		private var _row:int;
		private var _col:int;
		
		private var _rows:uint;
		private var _cols:uint;
		
		private var _overley:Boolean;
		private var _walkable:Boolean;
		
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		protected var _view:DisplayObject;
		private var _define:String;
		
		public function BaseMapItem()
		{
		}
		
		public function adjustPosition( x:Number, y:Number ) : void
		{
			if  ( this._view == null )
				return;
			
			_view.x = x + _offsetX;
			_view.y = y + _offsetY;
		}
		
		public function set define( value: String ) : void
		{
			_define = value;
		}
		public function get define() : String
		{
			return _define;
		}
		
		public function set row(value:int):void
		{
			_row = value;
		}
		
		public function get row():int
		{
			return _row;
		}
		
		public function set col(value:int):void
		{
			_col = value;
		}
		
		public function get col():int
		{
			return _col;
		}
		
		public function set rows(value:uint):void
		{
			_rows = value;
		}
		
		public function get rows():uint
		{
			return _rows;
		}
		
		public function set cols(value:uint):void
		{
			_cols = value;
		}
		
		public function get cols():uint
		{
			return _cols;
		}
		
		public function set isOverlap(value:Boolean):void
		{
			_overley = value;
		}
		
		public function get isOverlap():Boolean
		{
			return _overley;
		}
		
		public function set isWalkable(value:Boolean):void
		{
			_walkable = value;
		}
		
		public function get isWalkable():Boolean
		{
			return _walkable;
		}
		
		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}
		
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}
		
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		public function set view(value:DisplayObject):void
		{
			_view = value;
		}
		
		public function get view():DisplayObject
		{
			return _view;
		}
	}
}