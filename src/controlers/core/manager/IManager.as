package controlers.core.manager
{
	[Event(name="reg", type="controlers.core.manager.events.ManagerEvent")]
	
	[Event(name="unreg", type="controlers.core.manager.events.ManagerEvent")]
	
	[Event(name="dismiss", type="controlers.core.manager.events.ManagerEvent")]
	
	public interface IManager
	{
		function reg( key :String, item : IItem ) : void;
		
		function unreg( key :String ) : void;
		
		/**
		 * 
		 * 返回特定类型，继承的接口中覆盖？
		 * @return 
		 * 
		 */		
		function get( key :String ) : IItem ;
		
		function has( key :String ) :Boolean;
		
		function get count() :int;
		/**
		 * 销毁所有对象 
		 * 
		 */		
		function dismiss() : void;
	}
}