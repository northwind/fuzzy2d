package server
{

	/**
	 * 组装成server端可理解的格式，完成与server的通信 
	 * @author norris
	 * 
	 */	
	public interface IDataServer
	{
		function config( ip:String, port:uint ) :void;
		
		function send() : void;
		
		function receive() :void;
		
		function add( request:DataRequest ) : void;
		
		function remove( request:DataRequest ) : void;
		
	}
}