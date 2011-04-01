package
{
	/**
	 * 组件需用知道什么时候被初始化
	 * 为方便处理，约定：组件中如果需要依赖其他组件，则暴露variable或 accessor，
	 * 为提高效率建议尽量不要暴露不相关的属性。
	 * 同时 variable 只会被注射一次，accessor会被注射多次
	 * 
	 * @author norris
	 * 
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