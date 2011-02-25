package
{
	public interface IRoleModel extends IComponent
	{
		function getAttackNum() : int;
		
		function getHurt( damage : int ) : void;
		
		function updateHP() : void;
		
	}
}