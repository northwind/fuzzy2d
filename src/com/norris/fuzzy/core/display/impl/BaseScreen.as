package com.norris.fuzzy.core.display.impl
{
	import com.norris.fuzzy.core.display.ILayer;
	import com.norris.fuzzy.core.display.IScreen;
	
	import flash.display.DisplayObject;
	
	/**
	 * 按序添加layer 最后加优先级最高,倒序显示
	 * @author norris
	 * 
	 */	
	public class BaseScreen extends ContainerDisplay implements IScreen
	{
		private var _layers:Array = [];
		
		public function BaseScreen()
		{
			super();
		}
		
		public function push( layer:ILayer ):void
		{
			_layers.push( layer );
			
			this.addChild( layer as DisplayObject );
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