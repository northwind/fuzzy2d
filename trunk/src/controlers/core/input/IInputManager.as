package controlers.core.input
{
	import controlers.core.manager.IManager;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	 * TODO 包括鼠标左右键 
	 * @author sina
	 * 
	 */	
	public interface IInputManager
	{
		function init( area:Sprite ) : void;
		
		function on( key :uint , callback : Function ) : void;
		
		function un( key :uint, callback : Function = null ) : void;
		
		/**
		 *  不再响应键盘事件 
		 * @param value
		 * 
		 */		
		function set enableKeyboard( value:Boolean  ) : void;
		
		function get enableKeyboard() : Boolean;
	
		/**
		 *  不再响应鼠标事件 
		 * @param value
		 * 
		 */		
		function set enableMouse( value:Boolean  ) : void;
		
		function get enableMouse() : Boolean;
		
		/**
		 * 屏蔽特定的按键 
		 * @param keys
		 * 
		 */		
		function suspendKeys( keys:Array ) : void;
		/**
		 *  恢复屏蔽的按键 
		 * @param keys
		 * 
		 */		
		function resumeKeys( keys:Array ) : void;
		
	}
}