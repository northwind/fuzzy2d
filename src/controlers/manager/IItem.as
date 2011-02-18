package controlers.manager
{
	public interface IItem
	{
		function onReg( key:String, manager : IManager ) : void;
		
		function onUnreg( key:String, manager : IManager ) : void;
		
		function onDismiss( key:String, manager : IManager ) : void;
		
	}
}