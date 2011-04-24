package controlers.unit.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	
	import controlers.unit.IAttackable;
	import controlers.unit.Unit;
	
	public class BaseAttack extends BaseComponent implements IAttackable
	{
		public function BaseAttack()
		{
			super();
		}
		
		public function moveTo(to:Unit):void
		{
		}
		
		public function getAttackRange():Array
		{
			return null;
		}
		
		public function canAttack(to:Unit):Boolean
		{
			return false;
		}
	}
}