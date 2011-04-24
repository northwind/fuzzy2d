package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	
	import controlers.unit.IStuffable;
	
	import models.impl.StuffModel;
	
	public class BaseStuff extends BaseComponent implements IStuffable
	{
		private var _model:StuffModel;
		
		public function BaseStuff( model:StuffModel )
		{
			super();
			
			this._model = model;
		}
		
		public function get model():StuffModel
		{
			return _model;
		}
		
		public function applyTo(row:int, col:int):void
		{
		}
		
		public function getRange():Array
		{
			return null;
		}
		
		public function canApply(row:int, col:int):Boolean
		{
			return false;
		}
	}
}