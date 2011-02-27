package controlers.core.input
{
	import controlers.core.manager.IManager;
	
	import flash.display.Stage;
	
	public interface IInputManager
	{
		function init( stage:Stage ) : void;
		
		function on( key :uint , callback : Function ) : void;
		
		function un( key :uint, callback : Function = null ) : void;
		
		/**
		 *  不再处理键盘事件 
		 * @param value
		 * 
		 */		
		function set enable( value:Boolean  ) : void;
		
		function get enable() : Boolean;
	
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