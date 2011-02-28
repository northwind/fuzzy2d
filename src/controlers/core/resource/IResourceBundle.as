package controlers.core.resource
{
	public interface IResourceBundle
	{
		function set name( value:String ) : void;
		
		function get name() : String;
		
		//--------------------------
		function addResource ( resource:IResource ) : void;
		
		function removeResource( resource:IResource ) : void;
		
		function reload() : void;
		
		function pause() : void;
		
		function resume () : void;
		
		//----------------------------------
		function load() : void;
		
		function freeAll() : void;
		
		function get speed() : uint;
		
		//-------------------------------------
		function get failed() : Array;
		
		function reloadFailed() : void;
		
	}
}