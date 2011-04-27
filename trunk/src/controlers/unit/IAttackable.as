package controlers.unit
{
	import com.norris.fuzzy.core.cop.IComponent;
	
	import controlers.unit.IRange;
	
	public interface IAttackable extends IComponent
	{
		function attackTo( to:Unit ) : void;
		
		function get range():IRange;
		
		function showRange():void;
		
		function hideRange():void;
		
		function canAttack( to:Unit ) :Boolean;
		
		function get active():Boolean; 
		
	}
}