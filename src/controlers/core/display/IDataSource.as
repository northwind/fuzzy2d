package controlers.core.display
{
	import controlers.core.resource.IResource;

	public interface IDataSource
	{
		function set dataSource( value:IResource ) : void;
		
		function get dataSource() : IResource;
	}
}