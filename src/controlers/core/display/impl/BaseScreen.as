package controlers.core.display.impl
{
	import controlers.core.display.ILayer;
	import controlers.core.display.IScreen;
	
	import flash.display.DisplayObject;
	
	public class BaseScreen extends ContainerDisplay implements IScreen
	{
		public function BaseScreen()
		{
			super();
		}
		
		public function insert( layer:ILayer ):void
		{
			//一个级别只能存在一个层
			if ( this.get( layer.pri ) != null )
				this.remove( layer.pri );
			
			this.addChildAt( layer as DisplayObject , layer.pri );
//			this.reg( pri, layer );
		}
		
		public function remove(pri:uint):void
		{
			this.removeChildAt( pri );
//			this.unreg( pri );
		}
		
		public function get(pri:uint):ILayer
		{
			if ( this.numChildren <= pri )
				return null;
			
			return this.getChildAt( pri ) as ILayer ;
//			return this.getItem( pri );
		}

	}
}