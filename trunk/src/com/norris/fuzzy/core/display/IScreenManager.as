package com.norris.fuzzy.core.display
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	import flash.display.Sprite;
	
	public interface IScreenManager extends IComponent
	{
		function goto( name :String ) : void;
		
		function add( name:String, screen: IScreen ) : void;
		
		function get( name:String ) :IScreen;
		
		function remove( name:String ) :void;
	}
}