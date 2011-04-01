package com.norris.fuzzy.core.cop.impl
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.cop.IEntity;
	import com.norris.fuzzy.core.cop.impl.ComponentInfo;
	import com.norris.fuzzy.core.cop.impl.ComponentInfoFactory;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="complete", type="flash.events.Event")]
	
	public class Entity extends EventDispatcher implements IEntity
	{
		private var components:Array = [];
		protected var setuped:Boolean = false;
		
		public function Entity()
		{
		}
		
		public function addComponent(c:IComponent):void
		{
			//初始化后不再允许添加组件
			if ( this.setuped )
				return;
			
			components.push( ComponentInfoFactory.createComponentInfo( c ) );
			
		}
		
		public function setup():void
		{
			if ( setuped )
				return;
			
			setuped = true;
			
			//TODO 优化算法			
			for each ( var info:ComponentInfo in components ) {
				if ( info.hasParameter() ){
					for each ( var inject:ComponentInfo in components ) {
						if ( inject != info ){
							info.injectComponent( inject );
							
							if ( !info.hasParameter() ){
								break;
							}
						}
					}
				}
				
				//init
				info.component.onSetup();
			}
			
			this.dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function destroy():void
		{
			this.setuped = false;
			
			for each ( var info:ComponentInfo in components ) {
				info.component.destroy();
			}
			
			components = [];
		}
	}
}

