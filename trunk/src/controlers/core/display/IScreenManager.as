package controlers.core.display
{
	import flash.display.Sprite;
	
	public interface IScreenManager
	{
		function goto( name :String ) : void;
		
		function init( container:Sprite ) : void;
		
		function add( name:String, screen: IScreen ) : void;
		
		function get( name:String ) :IScreen;
		
		function remove( name:String ) :void;
	}
}