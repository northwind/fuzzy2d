package com.norris.fuzzy.core.display
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * 做为layers的载体，自身也有view属性，包含的layers也可做为screen中的component，进行依赖注射 
	 * @author norris
	 * 
	 */	
	public interface ILayerContainer extends ILayer
	{
		function push( layer:ILayer ) : void ;
		
		function get layers() :Array;
		
		function set clip( value:Rectangle ) :void;
		
		function get clip() :Rectangle;
	}
}