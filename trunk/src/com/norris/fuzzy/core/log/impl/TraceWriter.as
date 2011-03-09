package com.norris.fuzzy.core.log.impl
{
	import com.norris.fuzzy.core.log.ILogWriter;
	
	public class TraceWriter implements ILogWriter
	{
		public function TraceWriter()
		{
		}
		
		public function writeLog( level:String, content:String):void
		{
			trace( level + " : " + content );
		}
	}
}