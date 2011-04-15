package models.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import models.IDataModel;
	import models.event.ModelEvent;

	/**
	 * 开始加载 
	 */	
	[Event(name="start", type="models.event.ModelEvent")]
	
	/**
	 * 成功加载
	 */	
	[Event(name="completed", type="models.event.ModelEvent")]
	
	/**
	 * 加载失败 
	 */	
	[Event(name="error", type="models.event.ModelEvent")]
	
	public class BaseModel extends EventDispatcher implements IDataModel
	{
		protected var _data:*;
		
		public function BaseModel()
		{
			super();
		}
		
		public function loadData():void
		{
			this.dispatchEvent( new ModelEvent( ModelEvent.START, this ) );
		}
		
		protected function onCompleted( value:* ) : void
		{
			_data = value;
			
			this.dispatchEvent( new ModelEvent( ModelEvent.COMPLETED, this ) );	
		}
		
		protected function onError() : void
		{
			this.dispatchEvent( new ModelEvent( ModelEvent.ERROR, this ) );	
		}
		
		public function get data():*
		{
			return _data;
		}
		
	}
}