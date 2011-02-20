package controlers.core.log
{
	import controlers.core.log.impl.TraceWriter;

	public class Logger
	{
		public static const ERROR:String = "ERROR";
		public static const WARNING:String = "WARNING";
		public static const DEBUG:String = "DEBUG";
		public static const INFO:String = "INFO";
		
		private var _writer : ILogWriter;		
		private var _enable : Boolean = true;
		
		public function Logger()
		{
			_writer = new TraceWriter();
		}

		public function debug( message:String):void
		{
			writeLog( Logger.DEBUG, message );
		}
		
		public function info( message:String):void
		{
			writeLog( Logger.INFO, message );
		}
		
		public function warning( message:String):void
		{
			writeLog( Logger.WARNING, message );
		}
		
		public function error( message:String):void
		{
			writeLog( Logger.ERROR, message );
		}
		
		protected function writeLog( level:String, content:String  ) :void
		{
			if ( this._enable )
				_writer.writeLog( level, content );
		}
		
		public function set writer( writerObject : ILogWriter ) : void
		{
			_writer = writerObject;
		}
		
		public function get writer() : ILogWriter
		{
			return _writer;
		}

		public function set enable( value : Boolean ) : void
		{
			_enable = value;
		}
		
		public function get enable() : Boolean
		{
			 return _enable;
		}
		
	}
}