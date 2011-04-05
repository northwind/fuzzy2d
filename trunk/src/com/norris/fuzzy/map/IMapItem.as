package com.norris.fuzzy.map
{
	import flash.display.DisplayObject;

	public interface IMapItem
	{
		function set define( value: String ) : void;
		function get define() : String;
		
		function set row( value: int ) : void;
		function get row() : int;
		
		function set col( value: int ) : void;
		function get col() : int;
		
		function set rows( value: uint ) : void;
		function get rows() : uint;
		
		function set cols( value: uint ) : void;
		function get cols() : uint;
		
		function set isOverlap( value:Boolean ) : void;
		function get isOverlap() : Boolean;
		
		function set isWalkable( value:Boolean ) : void;
		function get isWalkable() : Boolean;
		
		function set offsetX( value:Number ) : void;
		function get offsetX() : Number;
		
		function set offsetY( value:Number ) : void;
		function get offsetY() : Number;
		
		function set view( value:DisplayObject ) : void;
		function get view() : DisplayObject;
		function adjustPosition( x:Number, y:Number ) : void;
	}
}