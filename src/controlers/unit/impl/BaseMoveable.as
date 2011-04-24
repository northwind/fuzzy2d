package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	
	import controlers.unit.IMoveable;
	
	public class BaseMoveable extends BaseComponent implements IMoveable
	{
		public function BaseMoveable()
		{
			super();
		}
		
		public function moveTo(row:int, col:int):void
		{
		}
		
		public function getMoveRange():Array
		{
			return null;
		}
		
		public function canMove(row:int, col:int):Boolean
		{
			return false;
		}
	}
}