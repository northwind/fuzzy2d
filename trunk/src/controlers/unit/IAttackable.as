package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	public interface IAttackable extends IComponent
	{
		function moveTo( to:Unit ) : void;
		
		function getAttackRange():Array;
		
		function canAttack( to:Unit ) :Boolean;
		
	}
}