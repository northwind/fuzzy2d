package com.norris.fuzzy.core.manager
{
	public interface IManager
	{
			function reg( key :String, item : * ) : void;
			
			function unreg( key :String ) : void;
			
			function find( key :String ) : * ;
			
			function getAll ()	: Object;
			
			function has( key :String ) :Boolean;
			
			function get count() :int;

			function dismiss() : void;
	}
}