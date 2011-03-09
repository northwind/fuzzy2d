package com.norris.fuzzy.core.input
{
	import com.norris.fuzzy.core.cop.IComponent;
	import com.norris.fuzzy.core.manager.IManager;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	 * 全局监管 键盘和鼠标
	 * @author sina
	 */	
	public interface IInputManager extends IComponent
	{
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