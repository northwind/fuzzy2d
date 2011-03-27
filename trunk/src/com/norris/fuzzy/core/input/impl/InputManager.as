package com.norris.fuzzy.core.input.impl
{
	import com.norris.fuzzy.core.input.IInputManager;
	import com.norris.fuzzy.core.input.impl.InputKey;
	import com.norris.fuzzy.core.log.Logger;
	import com.norris.fuzzy.core.manager.impl.BaseManager;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class InputManager extends BaseManager implements IInputManager
	{
		private var _enableKeyboard : Boolean = true;
		private var _enableMouse :Boolean = true;
		
		private var _dirtykeys :Array = [];
		
		public function InputManager( ct:Sprite )
		{
			if ( ct ){
				var stage:Stage = ct.stage;
				
				//TODO consider keyup
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false );
				//stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false );
				stage.addEventListener(MouseEvent.MOUSE_WHEEL  , onMouseWheel );
				stage.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown );
				stage.addEventListener(MouseEvent.MOUSE_UP , onMouseUp );
				
				ct.addEventListener(MouseEvent.MOUSE_MOVE  , onMouseMove, true );
				ct.addEventListener(MouseEvent.ROLL_OVER , onMouseOver );
				ct.addEventListener(MouseEvent.ROLL_OUT , onMouseOut );
				
				if ( ct.contextMenu != null )
					//area.contextMenu.addEventListener(Event.ACTIVATE, onContext );
					ct.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, onContext );
			}			
		}
		
		public function onSetup() : void
		{
		}
		
		public function destroy():void
		{
		}
		
		private function onKeyDown( event:KeyboardEvent ) : void
		{
			if ( !_enableKeyboard ){
				return;
			}
			
			var key:uint = event.keyCode;
//			Logger.debug( "InputManager on : key = " + key.toString() );
			
			//屏蔽特定按键
			if ( _dirtykeys.indexOf( key ) > -1  )
				return;
			
			excuteCallbacks( this.find( key.toString() ), event );
			excuteCallbacks( this.find( InputKey.ANYKEY.toString() ), event );
		}
		
		private function excuteCallbacks( arr:Array, event:Event ) : void
		{
			if ( arr == null )
				return;
			
			for each( var callback:Function in arr ){
				callback.call( null, event );
			}
		}
		
		private function onMouseDown( event:MouseEvent ) : void
		{
			if ( !_enableMouse ){
				return;
			}
			
			var key:uint = InputKey.MOUSE_LEFT;
			
			//屏蔽特定按键
			if ( _dirtykeys.indexOf( key ) > -1  )
				return;
			
			excuteCallbacks( this.find( InputKey.MOUSE_LEFT.toString() ), event );
			excuteCallbacks( this.find( InputKey.ANYKEY.toString() ), event );
		}
		
		private function onMouseUp( event:MouseEvent ) : void
		{
			if ( !_enableMouse ){
				return;
			}
			
			var key:uint = InputKey.MOUSE_UP;
			
			//屏蔽特定按键
			if ( _dirtykeys.indexOf( key ) > -1  )
				return;
			
			excuteCallbacks( this.find( InputKey.MOUSE_UP.toString() ), event );
		}		
		
		private function onMouseMove( event:MouseEvent ) : void
		{
			if ( !_enableMouse ){
				return;
			}
			
			var key:uint = InputKey.MOUSE_MOVE;
			
			//屏蔽特定按键
			if ( _dirtykeys.indexOf( key ) > -1  )
				return;
			
			excuteCallbacks( this.find( key.toString() ), event );
		}
		
		private function onMouseWheel( event:MouseEvent ) : void
		{
			if ( !_enableMouse ){
				return;
			}
			
			var key:uint = InputKey.MOUSE_WHEEL;
			
			//屏蔽特定按键
			if ( _dirtykeys.indexOf( key ) > -1  )
				return;
			
			excuteCallbacks( this.find( key.toString() ), event );
		}
		
		private function onMouseOver( event:MouseEvent ) : void
		{
			if ( !_enableMouse ){
				return;
			}
			
			var key:uint = InputKey.MOUSE_OVER;
			
			//屏蔽特定按键
			if ( _dirtykeys.indexOf( key ) > -1  )
				return;
			
			excuteCallbacks( this.find( key.toString() ), event );
		}
		
		private function onMouseOut( event:MouseEvent ) : void
		{
			if ( !_enableMouse ){
				return;
			}
			
			var key:uint = InputKey.MOUSE_OUT;
			
			//屏蔽特定按键
			if ( _dirtykeys.indexOf( key ) > -1  )
				return;
			
			excuteCallbacks( this.find( key.toString() ), event );
		}
		
		private function onContext ( event:Event ) : void
		{
			if ( !_enableMouse ){
				return;
			}
			
			var key:uint = InputKey.MOUSE_RIGHT;
			
			//屏蔽特定按键
			if ( _dirtykeys.indexOf( key ) > -1  )
				return;
			
			excuteCallbacks( this.find( key.toString() ), event );
			//任意键不包括右键
			//excuteCallbacks( this.getItem( InputKey.ANYKEY.toString() ), event );
		}
		
		public function on(key:uint, callback:Function):void
		{
			if ( callback == null ){
				Logger.warning( "InputManager on " + key + " : callback is null." );
				return;
			}
			var arr : Array = this.find( key.toString() );
			//new an array
			if ( arr == null )
				arr = [];
			
			if ( arr.indexOf( callback ) > -1 ){
				Logger.warning( "InputManager on " + key + " : callback is already exist." );
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
				var arr : Array = this.find( key.toString() );
				if ( arr != null ){
					var i:int = arr.indexOf( callback );
					if ( i > -1 ){
						arr.splice( i, 1 );
						this.reg( key.toString(), arr );
					}
				}
			}
		}
		
		public function set enableKeyboard(value:Boolean):void
		{
			_enableKeyboard = value;
		}
		
		public function get enableKeyboard():Boolean
		{
			return _enableKeyboard;
		}
		
		public function set enableMouse( value:Boolean  ) : void
		{
			_enableMouse = value;
		}
		
		public function get enableMouse() : Boolean
		{
			return _enableMouse;
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