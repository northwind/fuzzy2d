package controlers.core.manager
{
	public interface IItem
	{
		function onReg( key:String, manager : IStrictManager ) : void;
		
		function onUnreg( key:String, manager : IStrictManager ) : void;
		
		function onDismiss( key:String, manager : IStrictManager ) : void;
		
	}
}