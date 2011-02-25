package
{
	public interface IEntity
	{
		function addComponent( c :IComponent ) : void;
		
		//function getComponent( c:IComponent ) : void;
		
		//function setup() : void;
		
		function destroy() : void;
		
	}
}