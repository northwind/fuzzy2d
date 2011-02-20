package controlers.core.log.impl
{
	import controlers.core.log.ILogWriter;
	
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