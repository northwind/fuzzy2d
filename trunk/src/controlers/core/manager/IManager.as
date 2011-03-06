package controlers.core.manager
{
	public interface IManager
	{
			function reg( key :String, item : * ) : void;
			
			function unreg( key :String ) : void;
			
			function getItem( key :String ) : * ;
			
			function getAll ()	: Object;
			
			function has( key :String ) :Boolean;
			
			function get count() :int;

			function dismiss() : void;
	}
}