package com.norris.fuzzy.core.cop
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * IEntity 不知道内部的组件数量和属性
	 * @author norris
	 * 
	 */	
	public interface IEntity
	{
		function addComponent( c :IComponent ) : void;
		
		function hasComponent( c :IComponent ) : Boolean;
		//function getComponent( c:IComponent ) : void;
		
		function setup() : void;
		
		function destroy() : void;
		
	}
}