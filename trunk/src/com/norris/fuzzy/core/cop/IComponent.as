package com.norris.fuzzy.core.cop
{
	/**
	 * 为方便处理，约定：组件中如果需要依赖其他组件，则暴露variable或 accessor，
	 * variable 只会被注射一次，accessor会被注射多次
	 * @author norris
	 */	
	public interface IComponent
	{
		/**
		 * after inject 
		 * 
		 */		
		function onSetup() : void;
		
		//function onAdd() : void;
		
		function destroy() : void;
	}
}