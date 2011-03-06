package controlers.core.debug.impl
{
	import controlers.core.debug.IConsole;
	import controlers.core.debug.IDebugManamger;
	import controlers.core.log.Logger;
	import controlers.core.manager.impl.BaseStrictManager;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	import org.spicefactory.parsley.core.messaging.command.Command;
	
	public class BaseDebugManager extends BaseStrictManager implements IDebugManamger
	{
		private var _enable :Boolean = true;
		private var prefix:String = "";
		public var console :IConsole;
		
		private var container:Sprite;
		
		public function BaseDebugManager()
		{
			super();
		}
		
		public function init( container:Sprite ) : void
		{
			if ( container == null ){
				Logger.error( "BaseCommandManager init : container is null " );
				return;
			}
			
			this.container = container;
			this.console = new BaseConsole();
			this.console.hide();
			this.console.onEnter( this.excute );
			
			this.container.addChild( console as Sprite );
			
			addInternalCommands();
			
		}
		
		public function toggle() : void
		{
			this.console.toggle();
		}
		
		protected function addInternalCommands() : void
		{
			this.registerCommand( "help", this.onHelp, "list command." );
			this.registerCommand( "clear", this.console.clear, "clear console." );
			this.registerCommand( "exit", this.console.hide, "exit console." );
		}
		
		private function onHelp() : String
		{
			var ret :String = "";
			
			var all:Object = this.getAll();
			for( var key :String in all ){
				ret += key + "  :  " + ( all[ key ] as Command ).desc + "\n";
			} 
			
			return ret;	
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
			Logger.debug( "line : " + line );
			
			var method:String, args:Array;
			
			line = line.replace( /^\s*/, "" ).replace( /\s*$/, "" );
			
			var n:int = line.indexOf( " " );
			if ( n > -1 ){
				method = line.substr(0, n );
				args = line.substr(n+1, line.length ).split( "," );
				//消除空格
				for( var i : int =0 ; i < args.length; i ++ ){
					args[ i ] = (args[ i ] as String).replace( /^\s*/, "" ).replace( /\s*$/, "" );
				}				
			}else{
				method = "";
				args = [];
			}
			
			if ( method == "" ){
				console.writeLine( prefix );
				return;
			}
			
			var c:Command = this.getItem( method ) as Command;
			
			if ( c == null ){
				console.writeLine( prefix + method + " is not a command.", 0xff0000 );
				return;				
			}
			
			try{
				var ret:* = c.callback.apply( null, args );
				console.writeLine( ret is String ? ret : "", 0x00ff00 );
			}catch( e:Error ){
				console.writeLine( prefix + " error : " + e.toString(), 0xff0000 );
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
