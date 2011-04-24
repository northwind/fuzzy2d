package com.norris.fuzzy.core.debug.impl
{
	import com.norris.fuzzy.core.cop.impl.BaseComponent;
	import com.norris.fuzzy.core.debug.IConsole;
	import com.norris.fuzzy.core.debug.IDebugManamger;
	import com.norris.fuzzy.core.debug.Stats;
	import com.norris.fuzzy.core.input.IInputManager;
	import com.norris.fuzzy.core.input.impl.InputKey;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class BaseDebugManager extends BaseComponent implements IDebugManamger
	{
		protected var _enable :Boolean = true;
		private var prefix:String = "";
		private var console :IConsole;
		private var container:Sprite;
		private var _stats:Stats;
		private var _items:BaseManager = new BaseManager();
		
		public var inputMgr:IInputManager;
		
		public function BaseDebugManager( ct:Sprite )
		{
			super();
			
			this.container = ct;
			
			this.console = new BaseConsole();
			this.console.hide();
			this.console.onEnter( this.excute );
			
			this.container.addChild( console as Sprite );
			
			addInternalCommands();
			
			this.addEventListener(Event.COMPLETE, onSetupCompleted );
		}
		
		private function onSetupCompleted( event:Event ):void
		{
			this.removeEventListener( Event.COMPLETE, onSetupCompleted );
			
			if ( inputMgr ){
				inputMgr.on( InputKey.F12, function ( event:Event ): void{
					toggle();
				} );
			}
		}
		
		public function toggle() : void
		{
			this.console.toggle();
			
			//显示输入框时屏蔽键盘输入
//			if ( this.console.visible ){
//				inputMgr.enableKeyboard = false;	
//			}else{
//				inputMgr.enableKeyboard = true;
//			}
		}
		
		protected function addInternalCommands() : void
		{
			this.registerCommand( "help", this.onHelp, "list command." );
			this.registerCommand( "clear", this.console.clear, "clear console." );
			this.registerCommand( "exit", toggle, "exit console." );
			this.registerCommand( "fps", this.toggleStats, "show/hide fps indicator at [x,y]." );
		}
		
		/**
		 * 显示监控栏
		 * 参数为 x,y 
		 * @param rest
		 * 
		 */		
		private function toggleStats() : void
		{
			if ( _stats ){
				try{
					this.container.removeChild( _stats );
				}catch( e:Error){}
				_stats.destroy();
				_stats = null;
			}else{
				_stats = new Stats( arguments[0] || 20, arguments[1] );
				this.container.addChild( _stats );
			}
		}
		
		private function onHelp() : String
		{
			var ret :String = "";
			
			var all:Object = this._items.getAll();
			for( var key :String in all ){
				ret += key + "  :  " + ( all[ key ] as Command ).desc + "\n";
			} 
			
			return ret;	
		}
		
		public function registerCommand( name:String, callback:Function, desc :String = "" ) : void
		{
			if ( this._items.has( name ) ){
				Logger.warning( "registerCommand : " + name + " is already exist." );
				return;
			}
			if ( callback == null ){
				Logger.warning( "registerCommand : callback is null." );
				return;
			}
			
			var command :Command = new Command( name, callback, desc  ) ;
			this._items.reg( name, command );
		}
		
		public function unregisterCommand( name:String  ) : void
		{
			_items.unreg( name );
		}
		
		/**
		 * 执行命令
		 *  
		 * functionName + 空格 + 参数1,参数2,....
		 *  
		 */		
		public function excute(line:String ):void
		{
			if ( !_enable )
				return;
			
			var method:String, args:Array;
			
			line = line.replace( /^\s*/, "" ).replace( /\s*$/, "" );
			
			if ( line == "" ){
				console.writeLine( prefix );
				return;
			}
			
			var n:int = line.indexOf( " " );
			if ( n > -1 ){
				//带参数
				method = line.substr(0, n );
				args = line.substr(n+1, line.length ).split( "," );
				//消除空格
				for( var i : int =0 ; i < args.length; i ++ ){
					args[ i ] = (args[ i ] as String).replace( /^\s*/, "" ).replace( /\s*$/, "" );
				}				
			}else{
				//只有命令 无参数
				method = line;
				args = [];
			}
			
			var c:Command = this._items.find( method ) as Command;
			
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

import com.norris.fuzzy.core.manager.impl.BaseItem;

final class Command
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
