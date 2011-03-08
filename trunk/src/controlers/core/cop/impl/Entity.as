package controlers.core.cop.impl
{
	import controlers.core.cop.impl.ComponentInfo;
	import controlers.core.cop.impl.ComponentInfoFactory;
	import controlers.core.cop.IEntity;
	import controlers.core.cop.IComponent;
	
	public class Entity implements IEntity
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

