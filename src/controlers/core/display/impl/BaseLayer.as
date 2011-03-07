package controlers.core.display.impl
{
	import controlers.core.display.ILayer;
	
	public class BaseLayer extends ContainerDisplay implements ILayer
	{
		private var _pri:uint;
		
		public function BaseLayer()
		{
			super();
		}
		
		public function set pri(value:uint):void
		{
			this._pri = value;
		}
		
		public function get pri():uint
		{
			return this._pri;
		}
	}
}