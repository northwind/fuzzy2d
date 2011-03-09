package com.norris.fuzzy.core.log
{
	public interface ILogWriter
	{
		function writeLog( level:String, content:String ) : void;
	}
}