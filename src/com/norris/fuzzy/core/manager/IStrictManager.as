package com.norris.fuzzy.core.manager
{
	[Event(name="reg", type="com.norris.fuzzy.core.manager.events.ManagerEvent")]
	
	[Event(name="unreg", type="com.norris.fuzzy.core.manager.events.ManagerEvent")]
	
	[Event(name="dismiss", type="com.norris.fuzzy.core.manager.events.ManagerEvent")]
	
	public interface IStrictManager
	{
		function reg( key :String, item : IItem ) : void;
		
		function unreg( key :String ) : void;
		
		/**
		 * 
		 * 返回特定类型，继承的接口中覆盖？
		 * @return 
		 * 
		 */		
		function getItem( key :String ) : IItem ;

		function getAll ()	: Object;
		
		function has( key :String ) :Boolean;

		function get count() :int;
		/**
		 * 销毁所有对象 
		 * 
		 */		
		function dismiss() : void;
	}
}