package com.norris.fuzzy.core.display
{
	import com.norris.fuzzy.core.resource.IResource;

	public interface IDataSource
	{
		function set dataSource( value:IResource ) : void;
		
		function get dataSource() : IResource;
	}
}