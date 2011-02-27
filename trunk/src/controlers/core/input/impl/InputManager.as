package controlers.core.input.impl
{
	import controlers.core.input.IInputManager;
	import controlers.core.log.Logger;
	import controlers.core.manager.impl.BaseManager;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	public class InputManager extends BaseManager implements IInputManager
	{
		private var _enable : Boolean = true;
		private var _dirtykeys :Array = [];
		
		public function InputManager()
		{
		}
		
		public function init( stage:Stage ) : void
		{
			if ( stage ){
				//TODO consider keyup
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false );
			}
		}
		
		private function onKeyDown( event:KeyboardEvent ) : void
		{
			if ( !_enable ){
				return;
			}
			
			var key:uint = event.keyCode;
			Logger.debug( "InputManager on : key = " + key.toString() );
			
			//屏蔽特定按键
			if ( _dirtykeys.indexOf( key ) > -1  )
				return;
			
			var arr : Array = this.get( key.toString() );
			if ( arr != null ){
				for each( var callback:Function in arr ){
					callback.call();
				}
			}
		}
		
		public function on(key:uint, callback:Function):void
		{
			if ( callback == null ){
				Logger.error( "InputManager on : callback is null." );
				return;
			}
			var arr : Array = this.get( key.toString() );
			//new an array
			if ( arr == null )
				arr = [];
			
			if ( arr.indexOf( callback ) > -1 ){
				Logger.warning( "InputManager on : callback is already exist." );
			}else{
				arr.push( callback );
				this.reg( key.toString(), arr );
			}
		}
		
		/**
		 *  callback 为空时，key对应的回调方法全部注销
		 * @param key
		 * @param callback
		 * 
		 */		
		public function un(key:uint, callback:Function=null):void
		{
			if ( callback == null ){
				this.unreg( key.toString());
			}else{
				var arr : Array = this.get( key.toString() );
				if ( arr != null ){
					var i:int = arr.indexOf( callback );
					if ( i > -1 ){
						arr.splice( i, 1 );
						this.reg( key.toString(), arr );
					}
				}
			}
		}
		
		public function set enable(value:Boolean):void
		{
			_enable = value;
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function suspendKeys( keys:Array ) : void
		{
			if ( keys )	{
				_dirtykeys = _dirtykeys.concat(  keys );
			}
		}
		
		public function resumeKeys( keys:Array ) : void
		{
			if ( keys ){
				for each( var key:uint in keys ){
					var i : int = _dirtykeys.indexOf( key );
					if ( i > -1 )
						_dirtykeys.splice( i , 1 ); 
				}
			}
		}
		
	}
}