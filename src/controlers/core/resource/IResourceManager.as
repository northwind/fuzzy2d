package controlers.core.resource
{
	import flash.events.IEventDispatcher;
	
	public interface IResourceManager extends IEventDispatcher
	{
		function set local( value:String ) : void;
		
		//------------------------------
		function addResource ( resource:IResource ) : void;
		
		function removeResource( resource:IResource ) : void;

		function reloadResource( resource:IResource ) : void;
		
		function pauseResource ( resource:IResource ) : void;
		
		function resumeResource ( resource:IResource ) : void;
		
		function freeResource ( resource:IResource ) : void;
		
		function getResource( name:String ) : IResource;
		
		//--------------------------------
		function addBundle( bundle:IResourceBundle ) : void;
		
		function removeBundle( bundle:IResourceBundle ) : void;
		
		function reloadBundle( bundle:IResourceBundle ) : void;
		
		function pauseBundle ( bundle:IResourceBundle ) : void;
		
		function resumeBundle ( bundle:IResourceBundle ) : void;
		
		function freeBundle ( bundle:IResourceBundle ) : void;
		
		function getBundle( name:String ) : IResourceBundle;
		//----------------------------------
		function load() : void;
		
		function freeAll() : void;
		
		//function get speed() : uint;
		
		//-------------------------------------
		function get failed() : Array;
		
		//function reloadFailed() : void;
		
	}
}