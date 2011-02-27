package
{
	/**
	 * 供外部调用 
	 * @author norris
	 * 
	 */	
	public interface ICommandable extends IComponent
	{
		function reg( name:String, callback:Function ) : void;	
		
		function excute( method:String, params:Array, callback:Function = null ) : void;
		
	}
}