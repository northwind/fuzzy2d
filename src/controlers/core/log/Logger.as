package controlers.core.log
{
	import controlers.core.log.impl.TraceWriter;
	
	public class Logger
	{
		public static const ERROR:String = "ERROR";
		public static const WARNING:String = "WARNING";
		public static const DEBUG:String = "DEBUG";
		public static const INFO:String = "INFO";
		
		public static var writer : ILogWriter;		
		public static var enable : Boolean = true;
		
		public function Logger()
		{
		}
		
		public static function init( writer :ILogWriter ):void
		{
			if ( writer == null )
				return;
			
			Logger.writer = writer;
			
			info( "Logger inited." );
		}
		
		public static function debug( message:String):void
		{
			writeLog( Logger.DEBUG, message );
		}
		
		public static function info( message:String):void
		{
			writeLog( Logger.INFO, message );
		}
		
		public static function warning( message:String):void
		{
			writeLog( Logger.WARNING, message );
		}
		
		public static function error( message:String):void
		{
			writeLog( Logger.ERROR, message );
		}
		
		public static function writeLog( level:String, content:String  ) :void
		{
			if ( Logger.enable && Logger.writer )
				Logger.writer.writeLog( level, content );
		}
		
	}
}