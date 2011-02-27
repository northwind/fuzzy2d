package controlers.core.cop
{
	/**
	 * IEntity 不知道内部的组件数量和属性
	 * @author norris
	 * 
	 */	
	public interface IEntity
	{
		function addComponent( c :IComponent ) : void;
		
		//function getComponent( c:IComponent ) : void;
		
		function setup() : void;
		
		function destroy() : void;
		
	}
}