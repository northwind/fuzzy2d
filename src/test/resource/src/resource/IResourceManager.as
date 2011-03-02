package resource
{
	/**
	 * 负责资源的加载、读取和存放 
	 * name:* 支持单个资源名 或者 字符数组
	 * @author norris
	 * 
	 */	
	public interface IResourceManager
	{
		function set local( value:String ) : void;
		
		//------------------------------
		function add( name:String, url:String = null, policy:Boolean = false, type:Class = null ) :IResource;
		
		function load( name:Object, onProcess:Function = null, onComplete:Function = null ) : void;
		
		function reload( name:Object, onProcess:Function = null, onComplete:Function = null ) : void;
		
		function remove( name:Object ) :void;
		
		function stop ( name:Object ) :void;
		
		function destroyResource ( name:Object ) :void;
		
		function getResource ( name:String ) :IResource;
		
		//----------------------------------
		
		function destroyAll() : void;
	}
}