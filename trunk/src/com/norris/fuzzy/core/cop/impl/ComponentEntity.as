package com.norris.fuzzy.core.cop.impl
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.IEntity;
	import flash.events.Event;
	
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 既为实体亦为组件，可添加到父实体中，同时自身也接收注射
	 * @author norris
	 * 
	 */	
	public class ComponentEntity extends Entity implements IComponent, IEntity
	{
		public function ComponentEntity()
		{
			super();
			
			this.addComponent( this );
		}
		
		public function onSetup():void
		{
		}
	}
}