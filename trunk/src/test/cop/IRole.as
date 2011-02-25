package
{
	public interface IRole extends IEntity
	{
		function action( method:String, params:Array, callback:Function = null ) : void;
	}
}