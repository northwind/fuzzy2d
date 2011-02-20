package controlers.core.debug.impl
{
	import controlers.core.debug.ICommandManamger;
	import controlers.core.debug.IConsole;
	import controlers.core.log.Logger;
	import controlers.core.manager.impl.BaseManager;
	
	import org.spicefactory.parsley.core.messaging.command.Command;
	
	public class BaseCommandManager extends BaseManager implements ICommandManamger
	{
		private var _enable :Boolean = true;
		private var prefix:String = "C:\>";
		public var console :IConsole;
		
		
		public function BaseCommandManager()
		{
			super();
			this.init();
		}
		
		protected function init() : void
		{
			console = new BaseConsole();
			
			this.registerCommand( "help", this.onHelp, "list command." );
			this.registerCommand( "clear", this.console.clear, "clear console." );
			this.registerCommand( "exit", this.console.hide, "exit console." );
			
			this.registerCommand( "fps", function () :void {
				this.console.toggle();
			}, "toggle an fps indicator." );
			
		}
		
		private function onHelp() : void
		{
			
		}
		
		public function registerCommand( name:String, callback:Function, desc :String = "" ) : void
		{
			if ( this.has( name ) ){
				Logger.warning( "registerCommand : " + name + " is already exist." );
				return;
			}
			if ( callback == null ){
				Logger.warning( "registerCommand : callback is null." );
				return;
			}
			
			var command :Command = new Command( name, callback, desc  ) ;
			this.reg( name, command );
		}
		
		/**
		 * 执行命令
		 *  
		 * functionName + 空格 + 参数1,参数2,....
		 *  
		 */		
		public function excute(line:String ):void
		{
			var arr:Array = line.split( " " );
			var method:String = arr[0] , 
				   args:Array = arr[ 1 ] || arr[ 1 ].split( "," );
			
			if ( method == "" ){
				console.writeLine( prefix );
				return;
			}
			
			var c:Command = this.get( method ) as Command;
			
			if ( c == null ){
				console.writeLine( prefix + method + " is not a command." );
				return;				
			}
			
			try{
				c.callback.apply( args );
				console.writeLine( prefix + method + " " + args.join(",") );
			}catch( e:Error ){
				console.writeLine( prefix + " error : " + e.toString() );
			}
		}
		
		public function set enable( value:Boolean ) : void
		{
			_enable = value;
		}
		
	}
}

import controlers.core.manager.impl.BaseItem;

final class Command extends BaseItem
{
	public var name:String;
	public var callback:Function;
	public var desc:String;			
	
	public function Command( name:String, callback:Function, desc :String ){
		this.name = name;
		this.callback = callback;
		this.desc = desc;	
	}
}
